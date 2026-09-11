-- Create enum types
CREATE TYPE anime_status AS ENUM ('ongoing', 'completed', 'hiatus', 'cancelled');
CREATE TYPE anime_season AS ENUM ('winter', 'spring', 'summer', 'fall');
CREATE TYPE episode_status AS ENUM ('aired', 'upcoming', 'cancelled');
CREATE TYPE user_status AS ENUM ('watching', 'completed', 'on_hold', 'dropped', 'plan_to_watch');

-- Studios table
CREATE TABLE studios (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  country VARCHAR(100),
  founded_year INTEGER,
  website VARCHAR(500),
  description TEXT,
  logo_url VARCHAR(500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Genres table
CREATE TABLE genres (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Anime table
CREATE TABLE anime (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(500) NOT NULL,
  title_english VARCHAR(500),
  title_japanese VARCHAR(500),
  synopsis TEXT,
  status anime_status NOT NULL,
  aired_from DATE,
  aired_to DATE,
  episode_count INTEGER,
  episode_duration INTEGER, -- in minutes
  season anime_season,
  year INTEGER,
  score DECIMAL(3, 1),
  scored_by INTEGER,
  rank INTEGER,
  popularity_rank INTEGER,
  cover_image_url VARCHAR(500),
  banner_image_url VARCHAR(500),
  source VARCHAR(100), -- manga, light novel, game, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_episodes CHECK (episode_count > 0 OR status = 'ongoing'),
  CONSTRAINT valid_score CHECK (score >= 0 AND score <= 10)
);

-- Anime Studios relationship (many-to-many)
CREATE TABLE anime_studios (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  studio_id BIGINT NOT NULL REFERENCES studios(id) ON DELETE CASCADE,
  role VARCHAR(100), -- producer, animation studio, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(anime_id, studio_id)
);

-- Anime Genres relationship (many-to-many)
CREATE TABLE anime_genres (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  genre_id BIGINT NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(anime_id, genre_id)
);

-- Characters table
CREATE TABLE characters (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  name_japanese VARCHAR(255),
  description TEXT,
  character_role VARCHAR(100), -- Main, Supporting, etc.
  image_url VARCHAR(500),
  age INTEGER,
  gender VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Anime Characters relationship (many-to-many)
CREATE TABLE anime_characters (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  character_id BIGINT NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  role_in_anime VARCHAR(100), -- protagonist, antagonist, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(anime_id, character_id)
);

-- Voice Actors table
CREATE TABLE voice_actors (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  name_japanese VARCHAR(255),
  biography TEXT,
  birth_date DATE,
  birth_place VARCHAR(255),
  image_url VARCHAR(500),
  website VARCHAR(500),
  language VARCHAR(50), -- Japanese, English, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Character Voice Actor relationship (many-to-many)
CREATE TABLE character_voice_actors (
  id BIGSERIAL PRIMARY KEY,
  character_id BIGINT NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  voice_actor_id BIGINT NOT NULL REFERENCES voice_actors(id) ON DELETE CASCADE,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  language VARCHAR(50),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(character_id, voice_actor_id, anime_id, language)
);

-- Episodes table
CREATE TABLE episodes (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  episode_number INTEGER NOT NULL,
  title VARCHAR(500),
  title_japanese VARCHAR(500),
  synopsis TEXT,
  air_date DATE,
  status episode_status,
  duration INTEGER, -- in minutes
  filler BOOLEAN DEFAULT FALSE,
  recap BOOLEAN DEFAULT FALSE,
  rating DECIMAL(3, 1),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(anime_id, episode_number)
);

-- Themes (Opening and Ending songs)
CREATE TABLE themes (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  theme_type VARCHAR(50), -- opening, ending
  sequence INTEGER,
  title VARCHAR(500) NOT NULL,
  artist VARCHAR(255),
  episode_start INTEGER,
  episode_end INTEGER,
  lyrics_url VARCHAR(500),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reviews table
CREATE TABLE reviews (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  user_id UUID,
  rating INTEGER,
  review_text TEXT,
  spoiler BOOLEAN DEFAULT FALSE,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT valid_rating CHECK (rating >= 1 AND rating <= 10)
);

-- User Anime List (tracking)
CREATE TABLE user_anime_list (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  status user_status NOT NULL,
  score INTEGER,
  episodes_watched INTEGER DEFAULT 0,
  started_watching DATE,
  finished_watching DATE,
  is_favorite BOOLEAN DEFAULT FALSE,
  notes TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, anime_id),
  CONSTRAINT valid_episodes_watched CHECK (episodes_watched >= 0),
  CONSTRAINT valid_user_score CHECK (score IS NULL OR (score >= 1 AND score <= 10))
);

-- Related Anime (sequels, prequels, spin-offs)
CREATE TABLE related_anime (
  id BIGSERIAL PRIMARY KEY,
  anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  related_anime_id BIGINT NOT NULL REFERENCES anime(id) ON DELETE CASCADE,
  relation_type VARCHAR(100), -- sequel, prequel, spin-off, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(anime_id, related_anime_id, relation_type)
);

-- Create indexes for better query performance
CREATE INDEX idx_anime_status ON anime(status);
CREATE INDEX idx_anime_year ON anime(year);
CREATE INDEX idx_anime_score ON anime(score DESC);
CREATE INDEX idx_anime_popularity ON anime(popularity_rank);
CREATE INDEX idx_episodes_anime_id ON episodes(anime_id);
CREATE INDEX idx_episodes_air_date ON episodes(air_date);
CREATE INDEX idx_characters_anime_id ON anime_characters(anime_id);
CREATE INDEX idx_voice_actors_language ON voice_actors(language);
CREATE INDEX idx_user_anime_list_user_id ON user_anime_list(user_id);
CREATE INDEX idx_user_anime_list_status ON user_anime_list(status);
CREATE INDEX idx_reviews_anime_id ON reviews(anime_id);
CREATE INDEX idx_anime_genres_genre_id ON anime_genres(genre_id);
CREATE INDEX idx_anime_studios_studio_id ON anime_studios(studio_id);

-- Enable Row Level Security
ALTER TABLE anime ENABLE ROW LEVEL SECURITY;
ALTER TABLE episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_anime_list ENABLE ROW LEVEL SECURITY;
