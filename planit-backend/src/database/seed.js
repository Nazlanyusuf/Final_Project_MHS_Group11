import 'dotenv/config';
import db from '../config/db.js';

const venues = [
  {
    title:        'Elegant Wedding Organizer',
    category:     'Wedding',
    description:  'EO profesional untuk pernikahan mewah dengan dekorasi elegan dan layanan all-inclusive.',
    image_url:    'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1200&auto=format&fit=crop',
    address:      'Jl. Sudirman No.1, Jakarta Pusat',
    rating:       4.9,
    review_count: 128,
    price:        'Rp 25.000.000',
    packages: [
      { name: 'Gold',     price: 'Rp 25.000.000', description: 'Dekorasi + MC + Katering 200 pax' },
      { name: 'Platinum', price: 'Rp 45.000.000', description: 'All-inclusive + Foto + Video + Honeymoon' },
    ],
  },
  {
    title:        'Amanjiwo Hotel',
    category:     'Wedding',
    description:  'Resort mewah dengan pemandangan Candi Borobudur untuk pernikahan tak terlupakan.',
    image_url:    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?q=80&w=1200&auto=format&fit=crop',
    address:      'Borobudur, Magelang, Jawa Tengah',
    rating:       5.0,
    review_count: 84,
    price:        'Rp 120.000.000',
    packages: [
      { name: 'Intimate',  price: 'Rp 120.000.000', description: 'Hingga 50 tamu, outdoor ceremony' },
      { name: 'Grand',     price: 'Rp 250.000.000', description: 'Hingga 200 tamu, full service' },
    ],
  },
  {
    title:        'Le Blanc Event',
    category:     'Birthday',
    description:  'Spesialis dekorasi ulang tahun dan pesta privat dengan konsep modern.',
    image_url:    'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?q=80&w=1200&auto=format&fit=crop',
    address:      'Jl. Gatot Subroto No.22, Jakarta Selatan',
    rating:       4.7,
    review_count: 56,
    price:        'Rp 8.000.000',
    packages: [
      { name: 'Basic',   price: 'Rp 8.000.000',  description: 'Dekorasi + MC + Kue' },
      { name: 'Premium', price: 'Rp 18.000.000', description: 'Full dekorasi + Katering + Hiburan' },
    ],
  },
  {
    title:        'Pullman Jakarta',
    category:     'Seminar',
    description:  'Hotel bintang 5 dengan fasilitas ballroom dan ruang konferensi berkapasitas besar.',
    image_url:    'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?q=80&w=1200&auto=format&fit=crop',
    address:      'Jl. M.H. Thamrin, Jakarta Pusat',
    rating:       4.8,
    review_count: 200,
    price:        'Rp 15.000.000',
    packages: [
      { name: 'Half Day', price: 'Rp 15.000.000', description: 'Ruang + AV + Coffee break' },
      { name: 'Full Day', price: 'Rp 28.000.000', description: 'Ruang + AV + 2x Makan + Snack' },
    ],
  },
  {
    title:        'Vibe Studio',
    category:     'Concert',
    description:  'Venue indoor modern untuk konser, showcase, dan live performance.',
    image_url:    'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?q=80&w=1200&auto=format&fit=crop',
    address:      'Jl. Kemang Raya No.5, Jakarta Selatan',
    rating:       4.6,
    review_count: 42,
    price:        'Rp 30.000.000',
    packages: [
      { name: 'Showcase',  price: 'Rp 30.000.000', description: 'Kapasitas 300 orang + Sound system' },
      { name: 'Full Show', price: 'Rp 60.000.000', description: 'Kapasitas 800 orang + Lighting + Crew' },
    ],
  },
  {
    title:        'Frame Studio',
    category:     'Photoshoot',
    description:  'Studio foto profesional dengan berbagai set dan latar belakang untuk sesi foto.',
    image_url:    'https://images.unsplash.com/photo-1554941068-a252680d7172?q=80&w=1200&auto=format&fit=crop',
    address:      'Jl. Senopati No.10, Jakarta Selatan',
    rating:       4.5,
    review_count: 30,
    price:        'Rp 3.500.000',
    packages: [
      { name: 'Basic',      price: 'Rp 3.500.000', description: '2 jam + 20 foto edit' },
      { name: 'Full Day',   price: 'Rp 9.000.000', description: '8 jam + unlimited foto + 50 foto edit' },
    ],
  },
];

for (const v of venues) {
  const [existing] = await db.query('SELECT id FROM venues WHERE title = ?', [v.title]);
  if (existing.length > 0) continue;

  const [result] = await db.query(
    'INSERT INTO venues (title, category, description, image_url, address, rating, review_count, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [v.title, v.category, v.description, v.image_url, v.address, v.rating, v.review_count, v.price]
  );

  for (const pkg of v.packages) {
    await db.query(
      'INSERT INTO packages (venue_id, name, price, description) VALUES (?, ?, ?, ?)',
      [result.insertId, pkg.name, pkg.price, pkg.description]
    );
  }
}

console.log('Seeder selesai.');
process.exit(0);
