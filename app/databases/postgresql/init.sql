CREATE USER supabase_admin WITH PASSWORD 'postgres';
CREATE DATABASE supabase_db OWNER supabase_admin;
ALTER USER supabase_admin WITH SUPERUSER;
