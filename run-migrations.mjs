import { Client } from 'pg';
import { readFileSync, readdirSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const dir = path.join(__dirname, 'supabase', 'migrations');
const files = readdirSync(dir).filter(f => f.endsWith('.sql')).sort();

const client = new Client({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } });
await client.connect();

for (const f of files) {
  const sql = readFileSync(path.join(dir, f), 'utf8');
  process.stdout.write(`Applying ${f} ... `);
  try {
    await client.query(sql);
    console.log('OK');
  } catch (err) {
    console.log('FAILED: ' + err.message);
  }
}

await client.end();
console.log('Done.');
