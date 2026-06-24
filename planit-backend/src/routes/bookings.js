import { Router } from 'express';
import db from '../config/db.js';
import { authenticate } from '../middleware/auth.js';

const router = Router();

// GET /api/bookings?status=ongoing
router.get('/', authenticate, async (req, res) => {
  const { status } = req.query;
  try {
    let query  = `
      SELECT b.*, v.title AS venue_title, v.image_url, v.category
      FROM bookings b
      JOIN venues v ON v.id = b.venue_id
      WHERE b.user_id = ?
    `;
    const params = [req.user.id];
    if (status) {
      query += ' AND b.status = ?';
      params.push(status);
    }
    query += ' ORDER BY b.created_at DESC';

    const [rows] = await db.query(query, params);
    return res.json({ data: rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ data: [] });
  }
});

// POST /api/bookings
router.post('/', authenticate, async (req, res) => {
  const { venue_id, event_date, event_name, guest_count, notes } = req.body;
  if (!venue_id || !event_date) {
    return res.status(422).json({ success: false, message: 'venue_id dan event_date wajib diisi' });
  }

  try {
    const [result] = await db.query(
      `INSERT INTO bookings (user_id, venue_id, event_name, event_date, guest_count, notes, status)
       VALUES (?, ?, ?, ?, ?, ?, 'ongoing')`,
      [req.user.id, venue_id, event_name ?? null, event_date, guest_count ?? 1, notes ?? null]
    );
    const [rows] = await db.query('SELECT * FROM bookings WHERE id = ?', [result.insertId]);
    return res.status(201).json({ success: true, data: rows[0] });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Gagal membuat booking' });
  }
});

// PATCH /api/bookings/:id/cancel
router.patch('/:id/cancel', authenticate, async (req, res) => {
  try {
    await db.query(
      "UPDATE bookings SET status = 'cancelled' WHERE id = ? AND user_id = ?",
      [req.params.id, req.user.id]
    );
    return res.json({ success: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false });
  }
});

// PATCH /api/bookings/:id/complete
router.patch('/:id/complete', authenticate, async (req, res) => {
  try {
    await db.query(
      "UPDATE bookings SET status = 'completed' WHERE id = ? AND user_id = ?",
      [req.params.id, req.user.id]
    );
    return res.json({ success: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false });
  }
});

export default router;
