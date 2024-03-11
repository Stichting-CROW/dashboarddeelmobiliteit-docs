INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, gemeentenaam, null, gemeentecode, 'municipality', concat('cbs:', gemeentecode)
FROM gemeenten
WHERE water = 'NEE';

INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, buurtnaam, null, gemeentecode, 'neighborhood', concat('cbs:', buurtcode)
FROM buurten
WHERE water = 'NEE';

INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, wijknaam, null, gemeentecode, 'residential_area', concat('cbs:', wijkcode)
FROM wijken
WHERE water = 'NEE';

UPDATE zones 
SET area = ST_makevalid(area) 
WHERE NOT ST_isValid(area);
