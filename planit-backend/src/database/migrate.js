import 'dotenv/config';
import db from '../config/db.js';

const sql = `
CREATE TABLE IF NOT EXISTS users (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(100) NOT NULL UNIQUE,
  username     VARCHAR(50)  NOT NULL UNIQUE,
  password     VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS venues (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  title        VARCHAR(150) NOT NULL,
  category     VARCHAR(50)  NOT NULL,
  description  TEXT,
  image_url    VARCHAR(500),
  address      VARCHAR(255),
  rating       DECIMAL(2,1) DEFAULT 4.5,
  review_count INT DEFAULT 0,
  price        VARCHAR(50),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS packages (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  venue_id    INT NOT NULL,
  name        VARCHAR(100) NOT NULL,
  price       VARCHAR(50)  NOT NULL,
  description TEXT,
  FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bookings (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  venue_id    INT NOT NULL,
  event_name  VARCHAR(200),
  event_date  DATE NOT NULL,
  guest_count INT DEFAULT 1,
  notes       TEXT,
  status      ENUM('ongoing','completed','cancelled') DEFAULT 'ongoing',
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
  FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wishlist (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  venue_id   INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_wishlist (user_id, venue_id),
  FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
  FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE
);
`;

for (const statement of sql.split(';').map(s => s.trim()).filter(Boolean)) {
  await db.query(statement);
}

console.log('Migrasi selesai.');
process.exit(0);
