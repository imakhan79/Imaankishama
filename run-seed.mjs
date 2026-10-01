import { Client } from 'pg';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const sql = readFileSync(path.join(__dirname, 'supabase', 'seed.sql'), 'utf8');

const client = new Client({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } });
await client.connect();

process.stdout.write('Applying supabase/seed.sql ... ');
try {
  await client.query(sql);
  console.log('OK');
} catch (err) {
  console.log('FAILED: ' + err.message);
  process.exitCode = 1;
}

await client.end();
