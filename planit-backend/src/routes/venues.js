import { Router } from 'express';
import db from '../config/db.js';

const router = Router();

// GET /api/venues?category=Wedding
router.get('/', async (req, res) => {
  const { category } = req.query;
  try {
    let query  = 'SELECT * FROM venues';
    const params = [];
    if (category) {
      query += ' WHERE category = ?';
      params.push(category);
    }
    query += ' ORDER BY id ASC';

    const [venues] = await db.query(query, params);

    const data = await Promise.all(venues.map(async (v) => {
      const [packages] = await db.query(
        'SELECT * FROM packages WHERE venue_id = ?',
        [v.id]
      );
      return {
        ...v,
        review: String(v.review_count),
        packages,
      };
    }));

    return res.json({ data });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ data: [] });
  }
});

// GET /api/venues/:id
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await db.query('SELECT * FROM venues WHERE id = ?', [id]);
    if (!rows[0]) return res.status(404).json({ data: null });

    const [packages] = await db.query(
      'SELECT * FROM packages WHERE venue_id = ?',
      [id]
    );

    const venue = {
      ...rows[0],
      review: String(rows[0].review_count),
      packages,
    };

    return res.json({ data: venue });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ data: null });
  }
});

export default router;
