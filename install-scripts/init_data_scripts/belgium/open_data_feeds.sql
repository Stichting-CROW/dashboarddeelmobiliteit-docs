INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, last_time_updated, is_active) 
VALUES (
    'dott', 
    'https://gbfs.api.ridedott.com/public/v2/brussels/gbfs.json', 
    'full_gbfs', 
    'clean', 
    NOW(),
    true
);

INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, last_time_updated, is_active) 
VALUES (
    'dott', 
    'https://gbfs.api.ridedott.com/public/v2/charleroi/gbfs.json', 
    'full_gbfs', 
    'clean', 
    NOW(),
    true
);

INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, last_time_updated, is_active) 
VALUES (
    'dott', 
    'https://gbfs.api.ridedott.com/public/v2/ghent/gbfs.json', 
    'full_gbfs', 
    'clean', 
    NOW(),
    true
);

INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, last_time_updated, is_active) 
VALUES (
    'dott', 
    'https://gbfs.api.ridedott.com/public/v2/liege/gbfs.json', 
    'full_gbfs', 
    'clean', 
    NOW(),
    true
);

INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, last_time_updated, is_active) 
VALUES (
    'dott', 
    'https://gbfs.api.ridedott.com/public/v2/namur/gbfs.json', 
    'full_gbfs', 
    'clean', 
    NOW(),
    true
);
