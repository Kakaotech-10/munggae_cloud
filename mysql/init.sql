CREATE DATABASE IF NOT EXISTS munggaedatabase;

USE munggaedatabase;

CREATE TABLE IF NOT EXISTS member (
    member_id BIGINT NOT NULL PRIMARY KEY,
    community_id BIGINT NOT NULL,
    role VARCHAR(50) NOT NULL,
    course VARCHAR(50) NOT NULL,
    member_name VARCHAR(50) NOT NULL,
    member_name_english VARCHAR(50) NOT NULL,
    kakao_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS community (
    community_id BIGINT NOT NULL PRIMARY KEY,
    community_name VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS channel (
    channel_id BIGINT NOT NULL PRIMARY KEY,
    community_id BIGINT NOT NULL,
    channel_name VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (community_id) REFERENCES community(community_id)
);

CREATE TABLE IF NOT EXISTS member_channel (
    member_channel_id BIGINT NOT NULL PRIMARY KEY,
    channel_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (channel_id) REFERENCES channel(channel_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE IF NOT EXISTS post (
    post_id BIGINT NOT NULL PRIMARY KEY,
    channel_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    post_title VARCHAR(255) NOT NULL,
    post_content TEXT NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    FOREIGN KEY (channel_id) REFERENCES channel(channel_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE IF NOT EXISTS comment (
    comment_id BIGINT NOT NULL PRIMARY KEY,
    post_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    parent_comment_id BIGINT,
    comment_content TEXT NOT NULL,
    depth INT NOT NULL,
    is_deleted BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (post_id) REFERENCES post(post_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (parent_comment_id) REFERENCES comment(comment_id)
);

CREATE TABLE IF NOT EXISTS image (
    image_id BIGINT NOT NULL PRIMARY KEY,
    original_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS post_image (
    image_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    PRIMARY KEY (image_id, post_id),
    FOREIGN KEY (image_id) REFERENCES image(image_id),
    FOREIGN KEY (post_id) REFERENCES post(post_id)
);

CREATE TABLE IF NOT EXISTS member_image (
    image_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    PRIMARY KEY (image_id, member_id),
    FOREIGN KEY (image_id) REFERENCES image(image_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE USER 'exporter'@'%' IDENTIFIED BY '123' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
FLUSH PRIVILEGES;
