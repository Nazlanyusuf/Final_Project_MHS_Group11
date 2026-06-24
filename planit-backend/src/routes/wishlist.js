import { Router } from 'express';
import db from '../config/db.js';
import { authenticate } from '../middleware/auth.js';

const router = Router();

// GET /api/wishlist
router.get('/', authenticate, async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT v.*, w.id AS wishlist_id
       FROM wishlist w
       JOIN venues v ON v.id = w.venue_id
       WHERE w.user_id = ?
       ORDER BY w.created_at DESC`,
      [req.user.id]
    );
    return res.json({ data: rows });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ data: [] });
  }
});

// POST /api/wishlist/toggle
router.post('/toggle', authenticate, async (req, res) => {
  const { venue_id } = req.body;
  if (!venue_id) {
    return res.status(422).json({ success: false, message: 'venue_id wajib diisi' });
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM wishlist WHERE user_id = ? AND venue_id = ?',
      [req.user.id, venue_id]
    );

    if (rows.length > 0) {
      await db.query(
        'DELETE FROM wishlist WHERE user_id = ? AND venue_id = ?',
        [req.user.id, venue_id]
      );
      return res.json({ is_wishlisted: false });
    } else {
      await db.query(
        'INSERT INTO wishlist (user_id, venue_id) VALUES (?, ?)',
        [req.user.id, venue_id]
      );
      return res.json({ is_wishlisted: true });
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// DELETE /api/wishlist/:venueId
router.delete('/:venueId', authenticate, async (req, res) => {
  try {
    await db.query(
      'DELETE FROM wishlist WHERE user_id = ? AND venue_id = ?',
      [req.user.id, req.params.venueId]
    );
    return res.json({ success: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ success: false });
  }
});

export default router;
