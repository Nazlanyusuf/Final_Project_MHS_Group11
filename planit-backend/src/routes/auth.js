import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import db from '../config/db.js';
import { authenticate } from '../middleware/auth.js';

const router = Router();

// POST /api/auth/register
router.post('/register', async (req, res) => {
  const { name, email, username, password, date_of_birth } = req.body;
  const errors = {};

  if (!name)          errors.name          = ['Nama wajib diisi'];
  if (!email)         errors.email         = ['Email wajib diisi'];
  if (!username)      errors.username      = ['Username wajib diisi'];
  if (!password)      errors.password      = ['Password wajib diisi'];
  if (!date_of_birth) errors.date_of_birth = ['Tanggal lahir wajib diisi'];

  if (Object.keys(errors).length > 0) {
    return res.status(422).json({ errors });
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM users WHERE email = ? OR username = ?',
      [email, username]
    );
    if (rows.length > 0) {
      return res.status(422).json({
        errors: { email: ['Email atau username sudah digunakan'] },
      });
    }

    const hashed = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO users (name, email, username, password, date_of_birth) VALUES (?, ?, ?, ?, ?)',
      [name, email, username, hashed, date_of_birth]
    );

    return res.status(201).json({ success: true, message: 'Registrasi berhasil' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(422).json({ success: false, message: 'Email dan password wajib diisi' });
  }

  try {
    const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    const user   = rows[0];

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ success: false, message: 'Email atau password salah' });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    const { password: _, ...userSafe } = user;
    return res.json({ success: true, token, user: userSafe });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// POST /api/auth/logout
router.post('/logout', authenticate, (_, res) => {
  return res.json({ success: true, message: 'Logout berhasil' });
});

// GET /api/auth/profile
router.get('/profile', authenticate, async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, name, email, username, date_of_birth, created_at FROM users WHERE id = ?',
      [req.user.id]
    );
    if (!rows[0]) return res.status(404).json({ success: false, message: 'User tidak ditemukan' });
    return res.json({ success: true, user: rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// PUT /api/auth/profile
router.put('/profile', authenticate, async (req, res) => {
  const { name, username, date_of_birth } = req.body;
  try {
    await db.query(
      'UPDATE users SET name = COALESCE(?, name), username = COALESCE(?, username), date_of_birth = COALESCE(?, date_of_birth) WHERE id = ?',
      [name ?? null, username ?? null, date_of_birth ?? null, req.user.id]
    );
    const [rows] = await db.query(
      'SELECT id, name, email, username, date_of_birth, created_at FROM users WHERE id = ?',
      [req.user.id]
    );
    return res.json({ success: true, user: rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
