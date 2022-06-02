/*
    what is the Track name appearing most frequently in playlists
    Query [preprod] schema
*/

use LAB20220523
GO

select track_name, toptrack.track_uri, cnt as number_of_frequencies
from preprod.Track
INNER JOIN ( --join with track table to get the track name
    select top 1 track_uri, count(track_uri) cnt --this query gets the track_uri from playlisttrack table for the most frequently track
    from preprod.PlaylistTrack
    GROUP by track_uri
    order by cnt DESC
) toptrack
on toptrack.track_uri = preprod.Track.track_uri
order by cnt DESC