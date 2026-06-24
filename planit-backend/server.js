import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import authRoutes     from './src/routes/auth.js';
import venueRoutes    from './src/routes/venues.js';
import bookingRoutes  from './src/routes/bookings.js';
import wishlistRoutes from './src/routes/wishlist.js';

const app  = express();
const PORT = process.env.PORT || 8000;

app.use(cors());
app.use(express.json());

app.use('/api/auth',     authRoutes);
app.use('/api/venues',   venueRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/wishlist', wishlistRoutes);

app.get('/', (_, res) => res.json({ message: 'PlanIt API is running' }));

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
