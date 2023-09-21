
-- Import municipalities in zones table
INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
    SELECT ST_UNION(geom) as geom,
        INITCAP(LOWER(MIN(t_mun_nl))) as name, 
        null,
        'cnis5:' || cnis5_2023 as municipality,
        'municipality',
        'cnis5:' || cnis5_2023 as stat_code  
    FROM statistical_sectors_belgium
    GROUP BY cnis5_2023
;

-- Import statistical sectors in zones table
INSERT INTO zones (area, name, owner, municipality, zone_type, stats_ref)
    SELECT geom,
        INITCAP(LOWER(t_sec_nl)) as name, 
        null,
        'cnis5:' || cnis5_2023 as municipality,
        'residential_area',
        'cs:' || cs01012023 as stat_code 
    FROM statistical_sectors_belgium
; 

