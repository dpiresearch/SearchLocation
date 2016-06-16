--
-- This script is part of a larger process that gathers keywords based on ip addresses
-- converts them to Lat Lngs, and visualizes them on maps
-- 
--
-- This script grabs a file (swip_int.txt) that contains keywords, keyword counts and 
-- the ASN representation of the ip address where the keyword (search) originated.  
-- It then joins it with the Maxmind database (GeoLiteCity-Blocks.csv/GeoLiteCity-Location.csv)
-- in order to associate each keyword and associated count with a latlng
-- 

--
-- Note:  The Maxmind database can be downloaded here:
-- http://dev.maxmind.com/geoip/legacy/geolite/

--
-- Load file that associates each keyword and count with an ASN
-- The ASN was converted from IP address from a previous process
--
S = LOAD '/user/hadoop/tmp/swip_int.txt' USING PigStorage() as (site:int, lid:long, kw:chararray, count:int);
S1 = FOREACH S GENERATE *;

--
-- Load Maxmind block representation
-- This helps us map to latlngs later
--
G = LOAD '/user/hadoop/data/exp/ref/GeoLiteCity-Blocks.csv' USING PigStorage(',') as (start:long, end:long, loc:long);
G1 = FOREACH G GENERATE *;

--
-- Load Maxmind LatLng representation
--
L = LOAD '/user/hadoop/data/exp/ref/GeoLiteCity-Location.csv' USING PigStorage(',') as (index:long, country:chararray, l1:chararray, l2:chararray, l3:chararray, lat:float, lng:float);

L1 = FOREACH L GENERATE *;
L1 = FILTER L1 by (country == '"MX"');

-- L1L = LIMIT L1 10;
-- DUMP L1L;

-- 
-- Pair each keyword entry with each Maxmind block entry
-- Will filter out the relevant entries later
--
J = CROSS S, G;
JF = FOREACH J GENERATE S::site as site, S::lid as lid, G::start as start, G::end as end, G::loc as loc, S::kw as kw, S::count as count;

--
-- Filter out the ones that match the block entries.  This will match the keywords with LatLngs later
--
JFF = FILTER JF by (lid >= start AND lid <= end);
JFFF = FOREACH JFF GENERATE site, start, lid, end, loc, kw, count;

--
-- Get the LatLngs
--
J2 = JOIN JFF by loc, L1 by index;
J2F = FOREACH J2 GENERATE JFF::site, L1::country, L1::l1, L1::l2,L1::l3,L1::lat,L1::lng, JFF::loc, JFF::kw, JFF::count;

-- Debugging purposes
-- J2FL = LIMIT J2F 10;
-- DESCRIBE J2FL;
-- DUMP J2FL;
-- DESCRIBE J2F;

--
-- Store the results.  We can now visualize keywords on a map
--
STORE J2F INTO '/user/hadoop/tmp/swip_latlng';

