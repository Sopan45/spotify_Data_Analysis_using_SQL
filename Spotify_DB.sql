-- creating table --
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT COUNT(*) FROM spotify;

SELECT COUNT(distinct artist) FROM spotify;

SELECT COUNT(distinct track) FROM spotify;

SELECT distinct (album_type) FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min=0;

DELETE FROM spotify
WHERE duration_min=0;

SELECT COUNT(*) FROM spotify
WHERE danceability=0;

select min(energy) from spotify;

select distinct (most_played_on) from spotify;


------------------------------------------------------------------------------------
-- Easy level Category --
-- Q1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	STREAM > 1000000000;

-- Q2.List all albums along with their respective artists.
SELECT
	ARTIST,
	ALBUM
FROM
	SPOTIFY;

SELECT
	COUNT(DISTINCT ARTIST) AS TOTAL_ARTIST,
	COUNT(DISTINCT ALBUM) AS TOTAL_ALBUM
FROM
	SPOTIFY;

--Q3.Get the total number of comments for tracks where licensed = TRUE.
SELECT
	SUM(COMMENTS) as total_no_comments
FROM
	SPOTIFY
WHERE
	LICENSED = 'TRUE';

--Q4.Find all tracks that belong to the album type single.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	ALBUM_TYPE = 'single';

SELECT
	COUNT(TRACK)
FROM
	SPOTIFY
WHERE
	ALBUM_TYPE = 'single';
	
--Q5.Count the total number of tracks by each artist.
SELECT
	ARTIST,
	COUNT(TRACK) as total_num_of_songs
FROM
	SPOTIFY
GROUP BY
	ARTIST;

---------------------------------------------------------------------------------------
-- Medium Level Category--
--Q6.Calculate the average danceability of tracks in each album.
SELECT
	ALBUM,
	AVG(DANCEABILITY) as avg_danceability
FROM
	SPOTIFY
GROUP BY
	ALBUM;

--Q7.Find the top 5 tracks with the highest energy values.
SELECT
	TRACK,
	MAX(ENERGY) AS HIGHEST_ENERGY_VALUES
FROM
	SPOTIFY
GROUP BY
	TRACK
ORDER BY
	HIGHEST_ENERGY_VALUES DESC
LIMIT
	5;
--Q8.List all tracks along with their views and likes where official_video = TRUE.
SELECT
	track,
	SUM(views)as total_views,
	SUM(likes) as total_likes
FROM
	SPOTIFY
WHERE
	OFFICIAL_VIDEO = 'TRUE'
GROUP BY 1;
	
--Q9.For each album, calculate the total views of all associated tracks.
SELECT
	ALBUM,
	TRACK,
	SUM(VIEWS) AS TOTAL_VIEWS
FROM
	SPOTIFY
GROUP BY
	ALBUM,
	TRACK
ORDER BY
	3 DESC;
	
--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT
	TRACK,
COALESCE(SUM(CASE WHEN MOST_PLAYED_ON = 'Spotify' THEN STREAM END),0) AS MOST_STREAMED_ON_SPOTIFY,
COALESCE(SUM(CASE WHEN MOST_PLAYED_ON = 'youtube' THEN STREAM END),0) AS MOST_STREAMED_ON_YOUTUBE
FROM
	SPOTIFY
GROUP BY
	TRACK
	) as t1
WHERE  MOST_STREAMED_ON_SPOTIFY>MOST_STREAMED_ON_YOUTUBE
AND MOST_STREAMED_ON_YOUTUBE<>0;


----------------------------------------------------------------------------------------
--- Advanced Level Questions.
--Q11.Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking
AS
(SELECT
	ARTIST,
	TRACK,
	SUM(VIEWS) AS TOTAL_VIEWS,
	DENSE_RANK() OVER (
		PARTITION BY
			ARTIST
		ORDER BY
			SUM(VIEWS) DESC
	) AS RANK
FROM
	SPOTIFY
GROUP BY
	1,
	2
ORDER BY
	1,
	3 DESC
)
SELECT * FROM ranking
WHERE rank<=3;
--Q12.Write a query to find tracks where the liveness score is above the average.

SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	LIVENESS > (
		SELECT
			AVG(LIVENESS)
		FROM
			SPOTIFY
	);
--Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
WITH cte
AS (
SELECT album,
MAX(energy) as highest_energy,
MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1)
SELECT album, highest_energy-lowest_energy FROM cte
ORDER BY 2 DESC;







