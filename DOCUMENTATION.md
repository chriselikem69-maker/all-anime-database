# AllAnime Database - Comprehensive Documentation

A complete Supabase PostgreSQL database schema for storing all anime-related data.

## 📊 Database Schema Overview

### Core Tables (Anime Information)
- **anime** - Main anime series metadata
- **episodes** - Individual episodes with air dates, ratings
- **characters** - Character information
- **voice_actors** - Voice actor data across languages
- **studios** - Animation studios and production companies
- **genres** - Anime genre classifications
- **alternative_titles** - Different titles in different languages

### Production & Staff
- **production_staff** - Directors, screenwriters, composers, etc.
- **anime_production_staff** - Links anime to production staff with roles
- **soundtracks** - OST albums
- **soundtrack_tracks** - Individual tracks from soundtracks

### Broadcasting & Streaming
- **broadcast_stations** - TV networks that aired anime
- **anime_broadcast_stations** - Broadcast schedule and timing
- **streaming_platforms** - Netflix, Crunchyroll, etc.
- **anime_streaming** - Availability per region with dub/subtitle info

### Content & Marketing
- **merchandise** - Figures, posters, manga, plush, games, etc.
- **source_material** - Manga, light novels, visual novels, etc.
- **anime_source_material** - Link anime to source materials
- **themes** - Opening and ending songs
- **external_links** - MyAnimeList, official sites, social media

### Community & Reviews
- **reviews** - User reviews and ratings
- **user_anime_list** - Track user's watching/completed status
- **fan_communities** - Discord, forums, subreddits
- **anime_news** - Latest news and updates

### Ratings & Quality
- **content_ratings** - MPAA, TV ratings by country
- **parental_guides** - Violence, language, sexual content levels
- **awards** - Award nominations and wins
- **anime_statistics** - Aggregate viewing statistics

### Relationships & Tags
- **anime_relationships** - Sequels, prequels, spin-offs
- **tags** - Keywords and thematic tags
- **anime_tags** - Tag assignments
- **anime_characters** - Character appearances in anime
- **anime_genres** - Genre classifications
- **anime_studios** - Studio involvement
- **character_voice_actors** - Voice acting assignments per language

## 📋 Table Specifications

### Anime Table
```sql
- id: BIGSERIAL PRIMARY KEY
- title: VARCHAR(500) - Main title
- title_english: VARCHAR(500)
- title_japanese: VARCHAR(500)
- synopsis: TEXT
- status: ENUM (ongoing, completed, hiatus, cancelled)
- aired_from: DATE
- aired_to: DATE
- episode_count: INTEGER
- episode_duration: INTEGER (in minutes)
- season: ENUM (winter, spring, summer, fall)
- year: INTEGER
- score: DECIMAL(3,1) - Rating 0-10
- scored_by: INTEGER - Number of ratings
- rank: INTEGER - MyAnimeList rank
- popularity_rank: INTEGER
- cover_image_url: VARCHAR(500)
- banner_image_url: VARCHAR(500)
- source: VARCHAR(100) - manga, light novel, etc.
- rating: ENUM - Content rating
- official_website: VARCHAR(500)
- trailer_url: VARCHAR(500)
- total_viewers: INTEGER
- mal_id: INTEGER - MyAnimeList ID
```

### Episodes Table
```sql
- id: BIGSERIAL PRIMARY KEY
- anime_id: BIGINT (FK)
- episode_number: INTEGER
- title: VARCHAR(500)
- title_japanese: VARCHAR(500)
- synopsis: TEXT
- air_date: DATE
- status: ENUM (aired, upcoming, cancelled)
- duration: INTEGER (minutes)
- filler: BOOLEAN
- recap: BOOLEAN
- rating: DECIMAL(3,1)
```

### Characters Table
```sql
- id: BIGSERIAL PRIMARY KEY
- name: VARCHAR(255)
- name_japanese: VARCHAR(255)
- description: TEXT
- character_role: VARCHAR(100) - Main, Supporting, etc.
- image_url: VARCHAR(500)
- age: INTEGER
- gender: VARCHAR(50)
```

### Production Staff Table
```sql
- id: BIGSERIAL PRIMARY KEY
- name: VARCHAR(255)
- name_japanese: VARCHAR(255)
- biography: TEXT
- birth_date: DATE
- birth_place: VARCHAR(255)
- image_url: VARCHAR(500)
- website: VARCHAR(500)
```

### Voice Actors Table
```sql
- id: BIGSERIAL PRIMARY KEY
- name: VARCHAR(255) UNIQUE
- name_japanese: VARCHAR(255)
- biography: TEXT
- birth_date: DATE
- birth_place: VARCHAR(255)
- image_url: VARCHAR(500)
- website: VARCHAR(500)
- language: VARCHAR(50) - Japanese, English, Spanish, etc.
```

### Streaming Platforms Table
```sql
- id: BIGSERIAL PRIMARY KEY
- name: VARCHAR(255) UNIQUE
- website: VARCHAR(500)
- country: VARCHAR(100)
- subscription_required: BOOLEAN
- description: TEXT
- logo_url: VARCHAR(500)
```

### Anime Streaming Table
```sql
- anime_id: BIGINT (FK)
- streaming_platform_id: BIGINT (FK)
- region: VARCHAR(100)
- availability_start: DATE
- availability_end: DATE
- dubbed_available: BOOLEAN
- subtitled_available: BOOLEAN
- free_with_ads: BOOLEAN
- subscription_type: VARCHAR(100)
```

### Merchandise Table
```sql
- id: BIGSERIAL PRIMARY KEY
- anime_id: BIGINT (FK)
- name: VARCHAR(500)
- merchandise_type: ENUM (figure, poster, manga, light_novel, cd, clothing, plush, game, book, other)
- manufacturer: VARCHAR(255)
- release_date: DATE
- price: DECIMAL(10,2)
- currency: VARCHAR(3)
- product_url: VARCHAR(500)
- image_url: VARCHAR(500)
- description: TEXT
```

### Soundtracks Table
```sql
- id: BIGSERIAL PRIMARY KEY
- anime_id: BIGINT (FK)
- title: VARCHAR(500)
- composer: VARCHAR(255)
- release_date: DATE
- track_count: INTEGER
- duration_minutes: INTEGER
- label: VARCHAR(255)
- description: TEXT
- album_art_url: VARCHAR(500)
```

### Awards Table
```sql
- id: BIGSERIAL PRIMARY KEY
- anime_id: BIGINT (FK)
- award_name: VARCHAR(500)
- award_category: ENUM (Best Anime, Best Director, Best Character, Best OST, Best Opening, Best Ending, Audience Choice, Innovation)
- year: INTEGER
- won: BOOLEAN
- organization: VARCHAR(255)
- description: TEXT
```

### Content Ratings Table
```sql
- anime_id: BIGINT (FK)
- rating_system: VARCHAR(100) - MPAA, TV Rating, BBFC, etc.
- rating: ENUM (G, PG, PG-13, R, R+, Rx)
- country: VARCHAR(100)
- description: TEXT
```

### Parental Guides Table
```sql
- anime_id: BIGINT (FK) UNIQUE
- violence_level: INTEGER (1-10)
- language_level: INTEGER (1-10)
- sexual_content_level: INTEGER (1-10)
- substance_use_level: INTEGER (1-10)
- profanity_level: INTEGER (1-10)
- violence_description: TEXT
- language_description: TEXT
- sexual_content_description: TEXT
- substance_use_description: TEXT
- overall_advisory: TEXT
```

## 🔑 Key Features

✅ **Complete Anime Metadata** - Everything from synopses to ratings
✅ **Episode Information** - Air dates, durations, filler status
✅ **Character & Voice Acting** - Multilingual voice actor support
✅ **Production Credits** - Directors, screenwriters, composers, designers
✅ **Streaming Information** - Platform availability by region
✅ **Merchandise Tracking** - Figures, manga, CDs, games, clothing
✅ **Soundtracks** - Full OST with track listings
✅ **Awards & Recognition** - Award wins and nominations
✅ **Content Ratings** - Multiple rating systems (MPAA, TV Rating, etc.)
✅ **Parental Guides** - Content warnings with detailed levels
✅ **Broadcast Information** - TV network schedules
✅ **Relationships** - Sequels, prequels, spin-offs, side stories
✅ **Fan Communities** - Discord, forums, subreddits
✅ **Source Material** - Links to original manga/light novels
✅ **Statistics** - Aggregate viewing data
✅ **News & Updates** - Latest announcements
✅ **External Links** - MyAnimeList, official sites, social media
✅ **User Tracking** - Personal watch lists and ratings
✅ **Row Level Security** - User data protection

## 📈 Indexes

Performance indexes on:
- Anime: status, year, score, popularity rank
- Episodes: anime_id, air_date
- Characters: anime_id
- Voice Actors: language
- User Lists: user_id, status
- Reviews: anime_id
- Streaming: anime_id, platform_id, region
- Merchandise: anime_id, type
- Production Staff: role
- Tags: anime_id, tag_id
- News: published_at

## 🔐 Security

- Row Level Security (RLS) enabled on:
  - user_anime_list
  - reviews
  - parental_guides
  - streaming_platforms
  - anime_streaming
  - merchandise
  - fan_communities

## 🚀 Getting Started

1. Create a Supabase project
2. Run migrations in order:
   - `001_create_anime_tables.sql`
   - `002_insert_sample_data.sql`
   - `003_extended_anime_schema.sql`
   - `004_extended_sample_data.sql`
3. Use the provided SQL queries for data retrieval
4. Connect via Supabase client library or REST API

## 📝 Data Types Used

**Enums:**
- anime_status: ongoing, completed, hiatus, cancelled
- anime_season: winter, spring, summer, fall
- episode_status: aired, upcoming, cancelled
- user_status: watching, completed, on_hold, dropped, plan_to_watch
- content_rating: G, PG, PG-13, R, R+, Rx
- staff_role: Director, Screenwriter, Composer, Producer, Editor, Character Designer, Animation Director, Sound Director
- merchandise_type: figure, poster, manga, light_novel, cd, clothing, plush, game, book, other
- award_category: Best Anime, Best Director, Best Character, Best OST, Best Opening, Best Ending, Audience Choice, Innovation
- media_source: manga, light_novel, visual_novel, game, original, novel, web_novel, web_manga

## 📚 Available Queries

See `SQL_QUERIES.md` for 15+ comprehensive query examples including:
- Get all anime with genres and studios
- Find anime by streaming platform
- Top-rated anime
- Production staff credits
- Merchandise inventory
- Award winners
- Character voice actors
- Soundtrack information
- Content ratings and parental guides
- Fan communities
- Anime relationships and sequels
- Statistics and viewing counts
- And more...

## 💡 Use Cases

- Build anime recommendation engines
- Track personal anime watch lists
- Analyze anime production trends
- Merchandise catalog management
- Streaming availability checker
- Community analysis and engagement
- Content rating system implementation
- Award tracking and predictions
- Voice actor portfolio management
- News and update notifications

## 📞 Support

For issues or contributions, please refer to the repository's GitHub issues.

---

**Last Updated:** 2024
**Database Version:** 1.0.0
**Schema Version:** 4.0
