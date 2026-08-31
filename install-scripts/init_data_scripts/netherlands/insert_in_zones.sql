INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, gm_naam, null, gm_code, 'municipality', concat('cbs:', gm_code)
FROM gemeenten
WHERE water = 'NEE';

INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, bu_naam, null, gm_code, 'neighborhood', concat('cbs:', bu_code)
FROM buurten
WHERE water = 'NEE';

INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
SELECT geom, wk_naam, null, gm_code, 'residential_area', concat('cbs:', wk_code)
FROM wijken
WHERE water = 'NEE';

UPDATE zones 
SET area = ST_makevalid(area) 
WHERE NOT ST_isValid(area);
