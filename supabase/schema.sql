-- MediTrack Supabase Schema
-- Run this in Supabase SQL Editor after creating the project.
-- Tables mirror the local Drift schema v6 with added user_id RLS columns.

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. User Profiles
CREATE TABLE user_profiles (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  date_of_birth TEXT,
  blood_group TEXT,
  active_conditions TEXT,
  allergies TEXT,
  emergency_contact_name TEXT,
  emergency_contact_phone TEXT,
  emergency_contact_relation TEXT,
  phone_number TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Vitals Entries
CREATE TABLE vitals_entries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  logged_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  bp_systolic INT,
  bp_diastolic INT,
  blood_sugar_fasting DOUBLE PRECISION,
  blood_sugar_post_meal DOUBLE PRECISION,
  temperature_celsius DOUBLE PRECISION,
  weight_kg DOUBLE PRECISION,
  spo2_percent INT,
  notes TEXT,
  synced BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Medicines
CREATE TABLE medicines (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  dosage TEXT NOT NULL,
  frequency TEXT,
  times_per_day INT DEFAULT 1,
  scheduled_times TEXT NOT NULL DEFAULT '[]',
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Medicine Doses
CREATE TABLE medicine_doses (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  medicine_id BIGINT NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
  scheduled_at TIMESTAMPTZ NOT NULL,
  taken_at TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'taken', 'skipped')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Symptom Entries
CREATE TABLE symptom_entries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  symptom_name TEXT NOT NULL,
  severity INT NOT NULL CHECK (severity >= 1 AND severity <= 5),
  notes TEXT,
  logged_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Doctor Visits
CREATE TABLE doctor_visits (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  doctor_name TEXT NOT NULL,
  specialty TEXT DEFAULT '',
  clinic_or_hospital TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  visit_date TIMESTAMPTZ NOT NULL,
  follow_up_date TIMESTAMPTZ,
  prescription_paths TEXT DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Companion Health Scores
CREATE TABLE companion_health_scores (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  calculated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  score DOUBLE PRECISION NOT NULL,
  logging_factor DOUBLE PRECISION NOT NULL,
  vitals_factor DOUBLE PRECISION NOT NULL,
  adherence_factor DOUBLE PRECISION NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for common queries
CREATE INDEX idx_vitals_user_date ON vitals_entries(user_id, logged_at DESC);
CREATE INDEX idx_doses_user_status ON medicine_doses(user_id, status);
CREATE INDEX idx_doses_scheduled ON medicine_doses(user_id, scheduled_at);
CREATE INDEX idx_symptoms_user_date ON symptom_entries(user_id, logged_at DESC);
CREATE INDEX idx_visits_user_followup ON doctor_visits(user_id, follow_up_date);
CREATE INDEX idx_chs_user_date ON companion_health_scores(user_id, calculated_at DESC);
CREATE INDEX idx_medicines_user_active ON medicines(user_id, is_active);

-- Enable Row Level Security on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE vitals_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicines ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicine_doses ENABLE ROW LEVEL SECURITY;
ALTER TABLE symptom_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE companion_health_scores ENABLE ROW LEVEL SECURITY;

-- RLS policies: users can only see and modify their own data
-- USING clause controls visibility of existing rows (SELECT, UPDATE, DELETE)
-- WITH CHECK clause controls modification of new/changed rows (INSERT, UPDATE)
CREATE POLICY "users_own_profiles"
  ON user_profiles FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_vitals"
  ON vitals_entries FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_medicines"
  ON medicines FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_doses"
  ON medicine_doses FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_symptoms"
  ON symptom_entries FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_doctor_visits"
  ON doctor_visits FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "users_own_health_scores"
  ON companion_health_scores FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Auto-set user_id on insert for all tables
CREATE OR REPLACE FUNCTION set_user_id()
RETURNS TRIGGER AS $$
BEGIN
  NEW.user_id = auth.uid();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER set_user_id_profiles
  BEFORE INSERT ON user_profiles FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_vitals
  BEFORE INSERT ON vitals_entries FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_medicines
  BEFORE INSERT ON medicines FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_doses
  BEFORE INSERT ON medicine_doses FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_symptoms
  BEFORE INSERT ON symptom_entries FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_visits
  BEFORE INSERT ON doctor_visits FOR EACH ROW EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_user_id_chs
  BEFORE INSERT ON companion_health_scores FOR EACH ROW EXECUTE FUNCTION set_user_id();
