

--removing duplicates from regions after aggregating each province

create table regions_duplicates as
select * from regions
  WHERE id IN (SELECT id 
                  FROM (SELECT row_number() OVER (PARTITION BY region_code), id 
                           FROM regions) x 
                 WHERE x.row_number > 1);

delete from regions 
where id in (select r.id 
from regions r inner join regions_duplicates rd on r.id = rd.id)

--adding office codes to region table for automated searches
--add 'duplicates' back first since region ids are probably repeated validly across old provincial boundaries. 
--test
select r.region_code, r.province as region_province, d.province as duplicate_province from regions r inner join regions_duplicates d using (region_code) order by r.region_code

ALTER TABLE regions
  DROP CONSTRAINT regions_region_code_key CASCADE;

insert into regions 
(SELECT * FROM regions_duplicates);

select distinct province from regions;

copy regional_offices (province,office,office_no) from '/data/KirchhoffSurveyors/regional_offices.csv' with (format csv,header);

select * from regions r join regional_offices o USING (province)

copy (select r.province,r.region_code,r.typology,o.office,o.office_no from regions r join regional_offices o USING (province) ) TO '/tmp/offices.csv' with (format csv,header);

-- creating sg_province table

create table sg_province as select distinct province from regions;

alter table sg_province add column id serial not null;

select * from magisterial_districts
  WHERE id IN (SELECT id 
                  FROM (SELECT row_number() OVER (PARTITION BY name), id 
                           FROM magisterial_districts) x 
                 WHERE x.row_number > 1);

                 select * from magisterial_districts where lower(name) = 'moretele'
--m215 and m216 were both 'moretele' so I changed one to moretele_e and the other to moretele_w

--deleting dups from spatial layers - has minisass had them all along????

delete from riverline
  WHERE gid IN (SELECT gid 
                  FROM (SELECT row_number() OVER (PARTITION BY gdo_gid), gid 
                           FROM riverline) x 
                 WHERE x.row_number > 1);

--add relevant CRSs
--NO on Cape datum 40115-40133
--delete from spatial_ref_sys where srid >=40115 and srid <=40133;
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40115, 'Gavin', 40115, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",15],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=15 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40117, 'Gavin', 40117, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",17],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=17 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40119, 'Gavin', 40119, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",19],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=19 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40121, 'Gavin', 40121, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",21],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=21 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40123, 'Gavin', 40123, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",23],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=23 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40125, 'Gavin', 40125, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",25],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=25 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40127, 'Gavin', 40127, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",27],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=27 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs');
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40129, 'Gavin', 40129, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",29],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=29 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40131, 'Gavin', 40131, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",31],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=31 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40133, 'Gavin', 40133, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",33],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]', '+proj=tmerc +lat_0=0 +lon_0=33 +k=1 +x_0=0 +y_0=0 +axis=enu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +units=m +no_defs'); 


--NO on HBK94 40015-40033
--delete from spatial_ref_sys where srid >=40015 and srid <=40033;
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext,proj4text) VALUES 
(40015, 'Gavin', 40015, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",15],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=15 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40017, 'Gavin', 40017, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",17],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=17 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40019, 'Gavin', 40019, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",19],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=19 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40021, 'Gavin', 40021, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",21],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=21 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40023, 'Gavin', 40023, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",23],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=23 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40025, 'Gavin', 40025, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",25],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=25 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40027, 'Gavin', 40027, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",27],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=27 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40029, 'Gavin', 40029, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",29],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=29 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40031, 'Gavin', 40031, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",31],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=31 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'),
(40033, 'Gavin', 40033, 'PROJCS["Transverse_Mercator",GEOGCS["GCS_WGS_1984",DATUM["D_unknown",SPHEROID["WGS84",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",33],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]','+proj=tmerc +lat_0=0 +lon_0=33 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'); 



--SO on Cape datum in CAPE FEET 40215-40233
--delete from spatial_ref_sys where srid >=40215 and srid <=40233;
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40215, 'Gavin', 40215, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",15],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=15 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40217, 'Gavin', 40217, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",17],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=17 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40219, 'Gavin', 40219, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",19],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=19 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40221, 'Gavin', 40221, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",21],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=21 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40223, 'Gavin', 40223, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",23],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=23 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40225, 'Gavin', 40225, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",25],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=25 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40227, 'Gavin', 40227, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",27],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=27 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs');
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40229, 'Gavin', 40229, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",29],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=29 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40231, 'Gavin', 40231, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",31],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=31 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs'); 
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) VALUES (40233, 'Gavin', 40233, 'PROJCS["Transverse_Mercator_South_Orientated",GEOGCS["GCS_unnamed ellipse",DATUM["D_unknown",SPHEROID["Unknown",6378249.145,293.4663076999908]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Transverse_Mercator_South_Orientated"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",33],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Cape_Feet",0.314858]]', '+proj=tmerc +lat_0=0 +lon_0=33 +k=1 +x_0=0 +y_0=0 +axis=wsu +a=6378249.145 +b=6356514.966398753 +towgs84=-136,-108,-292,0,0,0,0 +to_meter=0.314858 +no_defs');


insert into parcels_external (id,geom) 
(select id,geom from dam_17);
drop table dam_17;

insert into parcels_external (id,geom) 
(select sgkey,geom from dam_5);
drop table dam_5;

insert into parcels_external (geom) 
(select geom from dam_7);
drop table dam_7;

insert into parcels_external (id,geom) 
(select id,geom from dam_7b);
drop table dam_7b;


CREATE ROLE editor
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
  CREATE ROLE grace LOGIN ENCRYPTED PASSWORD 'md545e9dd0ce18784a8adbb33b88ca8e936'
   VALID UNTIL 'infinity';
GRANT editor TO grace;
CREATE ROLE simba LOGIN ENCRYPTED PASSWORD 'md5a73ae0a8106ff455e05addd1578c32d7'
   VALID UNTIL 'infinity';
GRANT editor TO simba;
CREATE ROLE sinethemba LOGIN ENCRYPTED PASSWORD 'md59dafdceae896d3349a4ec58099ba4940'
   VALID UNTIL 'infinity';
GRANT editor TO sinethemba;
CREATE ROLE grantvn LOGIN ENCRYPTED PASSWORD 'md559caae0e27efb6199428672e332a94b4'
   VALID UNTIL 'infinity';
GRANT editor TO grantvn;
CREATE ROLE samuel LOGIN ENCRYPTED PASSWORD 'md545e9dd0ce18784a8adbb33b88ca8e936'
   VALID UNTIL 'infinity';
GRANT editor TO samuel;
CREATE ROLE francois LOGIN ENCRYPTED PASSWORD 'md5db3cf67206afa8a1cd5bd6b5c70e3351'
   VALID UNTIL 'infinity';
GRANT editor TO francois;

CREATE ROLE guest LOGIN ENCRYPTED PASSWORD 'md5fe4ceeb01d43a6c29d8f4fe93313c6c1'
   VALID UNTIL 'infinity';

--moving captured data into DB

dwaregister=# copy parcels_aggregate (sg_off_name,sg_off_code,mjrcode,mnrcode,farm_no,portion,prev_parent_portion,remainder,sg_town_code,lpi_code,registered_owner,province,mag_district,reg_division,deed_office,diagram_no,parent,deed_no,compilation,compilation_new,town,farm_name,area,qds,right_type,right1,right2,right3,scheme_name,scheme_ref_num,kode,captured_by) from '/data/KirchhoffSurveyors/revit-machine/DWA DAMS REGISTER AS PER TOR/parcels_aggregate.csv' with (format csv,header);

--identifying unique records
--drop table parcels_duplicates;
CREATE TABLE parcels_duplicates AS
SELECT * FROM (SELECT row_number() OVER (PARTITION BY lpi_code), * 
                           FROM parcels_aggregate) x 
                 WHERE x.row_number > 1;
                 
DELETE FROM parcels_aggregate WHERE id IN
(SELECT id FROM (SELECT row_number() OVER (PARTITION BY lpi_code), id 
                           FROM parcels_aggregate) x 
                 WHERE x.row_number > 1);

CREATE TABLE parcels_lpi_null AS
select * FROM parcels_aggregate WHERE lpi_code IS NULL;
DELETE FROM parcels_aggregate WHERE lpi_code IS NULL;

CREATE TABLE diagram_no_duplicate AS
SELECT * FROM (SELECT row_number() OVER (PARTITION BY diagram_no), * 
                           FROM parcels_aggregate) x 
                 WHERE x.row_number > 1;
                 
DELETE FROM parcels_aggregate WHERE id IN
(SELECT id FROM (SELECT row_number() OVER (PARTITION BY diagram_no), id 
                           FROM parcels_aggregate) x 
                 WHERE x.row_number > 1);

CREATE TABLE diagram_no_null AS
select * FROM parcels_aggregate WHERE diagram_no IS NULL;
DELETE FROM parcels_aggregate WHERE diagram_no IS NULL;

--later after setting some more dud diagram_no's to null:
insert into diagram_no_null 
select * FROM parcels_aggregate WHERE diagram_no IS NULL;
DELETE FROM parcels_aggregate WHERE diagram_no IS NULL;

--populate lookups and ensure these records have those values so that they can insert cleanly into parcel_description

INSERT INTO parcel_description (sg_off_name,sg_off_code,mjrcode,mnrcode,farm_no,portion,prev_parent_portion,remainder,sg_town_code,lpi_code,registered_owner,province,mag_district,reg_division,deed_office,diagram_no,parent,deed_no,compilation,compilation_new,town,farm_name,area,area_unit,scheme_name,scheme_ref_num,kode,captured_by)
SELECT sg_off_name,sg_off_code,mjrcode,mnrcode::integer,farm_no::integer,portion::integer,prev_parent_portion::integer,remainder,sg_town_code,lpi_code,registered_owner,province,upper(mag_district),reg_division,deed_office,diagram_no,parent,deed_no,compilation,compilation_new,town,farm_name,area::double precision,area_unit,scheme_name,scheme_ref_num,kode::integer,captured_by FROM parcels_aggregate; 

select * from parcels_aggregate where prev_parent_portion !~ '[0-9]+'
--update parcels_aggregate set prev_parent_portion = NULL WHERE prev_parent_portion !~ '[0-9]+'
select prev_parent_portion::integer from parcels_aggregate 
--update parcels_aggregate set prev_parent_portion = NULL WHERE prev_parent_portion like '%/%'


ALTER TABLE parcel_description
   ALTER COLUMN crs DROP NOT NULL;

   select max(length(area_unit)) from parcels_aggregate;

update parcels_aggregate set diagram_no = null where diagram_no in ('Not Clear','Unclear','Not clear')

update parcels_aggregate set area = 1600, area_unit = 'morgen' where area = '1600morgen'
update parcels_aggregate set area = null where area = '160Square'

ALTER TABLE parcel_description
   ALTER COLUMN diagram_no DROP NOT NULL;
   
--area_unit - units
alter table parcels_aggregate add column area_unit character varying;
alter table parcels_aggregate add column area_raw character varying;
update parcels_aggregate set area_raw = area;
update parcels_aggregate set area = NULL, area_unit = NULL;

update parcels_aggregate set area_unit = 'morgen' 
where area_raw ilike '%morg_n%';
update parcels_aggregate set area = (regexp_split_to_array(area_raw, E'[,\\s]+'))[1]
where area_unit = 'morgen';

update parcels_aggregate set area_unit = 'hectare' 
where area_raw ilike '%he_ta__%';
update parcels_aggregate set area = (regexp_split_to_array(area_raw, E'[,\\s]+'))[1]
where area_unit = 'hectare';

update parcels_aggregate set area_unit = 'square feet' 
where area_raw ilike '%feet%';
update parcels_aggregate set area = (regexp_split_to_array(area_raw, E'[,\\s]+'))[1]
where area_unit = 'square feet';

update parcels_aggregate set area_unit = 'acre' 
where area_raw ilike '%acre%';
update parcels_aggregate set area = (regexp_split_to_array(area_raw, E'[,\\s]+'))[1]::double precision
where area_unit = 'acre' AND (regexp_split_to_array(area_raw, E'[,\\s]+'))[1] ~ '[0-9]+';

update parcels_aggregate set area_unit = 'square metres' 
where area_raw ilike '%sq__re met%';
update parcels_aggregate set area = (regexp_split_to_array(area_raw, E'[,\\s]+'))[1]
where area_unit = 'square metres';

select distinct area_raw from parcels_aggregate where area_unit is null;

select distinct area,area_unit,area_raw from parcels_aggregate order by area_unit,area;

--unit - units
select * from units;
insert into units (unit,factor,class) VALUES ('hectare',10000,'area');
insert into units (unit,factor,class) VALUES ('square feet',0.092902267,'area');
insert into units (unit,factor,class) VALUES ('acre',4046.8564,'area');
insert into units (unit,factor,class) VALUES ('square roods',1011.7141,'area');

--there are too many other cases to waste time converting these. 

--mag_district - magisterial_districts

select distinct mag_district from parcels_aggregate

select distinct p.mag_district,md.name from parcels_aggregate p LEFT JOIN magisterial_districts md ON lower(p.mag_district) = lower(md.name)

select name from magisterial_districts where name ilike '%mooi%'
--can't find Pongola

CREATE TABLE mag_dist_no_match AS
SELECT p.* FROM parcels_aggregate p LEFT JOIN magisterial_districts m ON lower(p.mag_district) = lower(m.name) WHERE m.name IS NULL AND p.mag_district IS NOT NULL;                 
DELETE from parcels_aggregate WHERE id IN 
(SELECT p.id FROM parcels_aggregate p LEFT JOIN magisterial_districts m ON lower(p.mag_district) = lower(m.name) WHERE m.name IS NULL AND p.mag_district IS NOT NULL);

update parcels_aggregate set mag_district = 'Stutterheim' where mag_district ilike '%stutterheim%'
update parcels_aggregate set mag_district = 'mooirivier' where mag_district ilike '%mooi%riv%r%'

alter table parcels_aggregate add column mag_dist_raw character varying;
update parcels_aggregate set mag_dist_raw = mag_district;
update parcels_aggregate set mag_district = NULL;

update parcels_aggregate p set mag_district = md.name
FROM magisterial_districts md WHERE lower(p.mag_dist_raw) = lower(md.name)
returning *

select name from magisterial_districts order by name --where name ilike '%worc%' 
select mag_district from parcels_aggregate order by mag_district  

--mjrcode - major_codes
insert into major_codes (code)
select distinct mjrcode from parcels_aggregate where mjrcode is not null;

--mnrcode - minor_codes
insert into minor_codes (code)
select distinct mnrcode::integer from parcels_aggregate where mnrcode is not null;

--province - sg_province

select distinct province from parcels_aggregate where province is not null;

select distinct p.province,pr.province from parcels_aggregate p LEFT JOIN sg_province pr ON pr.province ilike '%'||p.province||'%'

select * from sg_province
select distinct province from provinces
insert into sg_province (province) VALUES
('North West'),
('Northern Cape');

alter table parcels_aggregate add column province_raw character varying;
update parcels_aggregate set province_raw = province;
update parcels_aggregate set province = NULL;

update parcels_aggregate set province = 
CASE 
WHEN province_raw ilike '%puma%' THEN 'Mpumalanga'
WHEN province_raw ilike '%lim%' THEN 'Limpopo'
WHEN province_raw ilike '%zulu%' THEN 'KwaZulu-Natal'
WHEN province_raw ilike '%east%' THEN 'Eastern Cape'
WHEN province_raw ilike '%free%' THEN 'Free State'
WHEN province_raw ilike '%gaut%' THEN 'Gauteng'
WHEN province_raw ilike '%north%west%' THEN 'North West'
WHEN province_raw ilike '%orth%cape%' THEN 'Northern Cape'
WHEN province_raw ilike '%west%' THEN 'Western Cape'
END;

select distinct province,province_raw from parcels_aggregate;

--need old provinces AND new provinces?

--qds - sheet50

--not adding these...do the same as link tables for dams and rights

--region - regions

--not sure which field this maps to

--sg_off_code - sg_offices

select distinct sg_off_name,sg_off_code from parcels_aggregate

--leave code as is

insert into 

--sg_off_name - sg_offices

select distinct sg_off_name from parcels_aggregate

alter table parcels_aggregate add column sg_off_name_raw character varying;
update parcels_aggregate set sg_off_name_raw = sg_off_name;
update parcels_aggregate set sg_off_name = NULL;

update parcels_aggregate set sg_off_name = 
CASE 
WHEN sg_off_name_raw ilike '%puma%' THEN 'Mpumalanga'
WHEN sg_off_name_raw ilike '%lim%' THEN 'Limpopo'
WHEN sg_off_name_raw ilike '%zulu%' THEN 'KwaZulu-Natal'
WHEN sg_off_name_raw ilike '%east%' THEN 'Eastern Cape'
WHEN sg_off_name_raw ilike '%free%' THEN 'Free State'
WHEN sg_off_name_raw ilike '%gaut%' THEN 'Gauteng'
WHEN sg_off_name_raw ilike '%north%west%' THEN 'North West'
WHEN sg_off_name_raw ilike '%orth%cape%' THEN 'Northern Cape'
WHEN sg_off_name_raw ilike '%west%' THEN 'Western Cape'
END;

--loading SG data

GRANT USAGE ON SCHEMA sg TO GROUP editor;
ALTER DEFAULT PRIVILEGES IN SCHEMA sg
    GRANT SELECT ON TABLES
    TO editor;

grant select on all tables in schema sg to editor;

select distinct sg_off_name,sg_off_name_raw from parcels_aggregate;

insert into sg_offices (name)
select distinct sg_off_name from parcels_aggregate;

insert into sg_office_codes (code)
select distinct sg_off_code from parcels_aggregate;


--figure out how to deal with rights
right1,right2,right3
--drop table rights;
CREATE TABLE rights
(
  id serial NOT NULL,
  number character varying(15),
  right_type character varying(20),
  description text,
  CONSTRAINT rights_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE rights
  OWNER TO gavin;
GRANT ALL ON TABLE rights TO gavin;
GRANT SELECT ON TABLE rights TO public;
GRANT SELECT, UPDATE, INSERT ON TABLE rights TO editor;

select distinct right1, right2, right3 from parcels_aggregate;

CREATE TABLE right_prop_link
(
  id serial NOT NULL,
  sgcode character varying(25) NOT NULL,
  right_id integer NOT NULL,
  CONSTRAINT right_prop_link_pkey PRIMARY KEY (id),
  CONSTRAINT right_prop_link_right_id_fkey FOREIGN KEY (right_id)
      REFERENCES rights (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT right_prop_link_sgcode_fkey FOREIGN KEY (sgcode)
      REFERENCES parcel_description (lpi_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE right_prop_link
  OWNER TO gavin;
GRANT ALL ON TABLE right_prop_link TO gavin;
GRANT SELECT ON TABLE right_prop_link TO public;
GRANT SELECT, UPDATE, INSERT ON TABLE right_prop_link TO editor;

--moving rights values into right_prop_link

insert into rights (description)
(select right1 from parcels_aggregate
UNION
SELECT right2 from parcels_aggregate
UNION 
SELECT right3 FROM parcels_aggregate)

--run after populating parcel_description
insert into right_prop_link (sgcode,right_id)
(select p.lpi_code,r.id from parcels_aggregate p inner join rights r ON p.right1 = r.description
union
select p.lpi_code,r.id from parcels_aggregate p inner join rights r ON p.right2 = r.description
union
select p.lpi_code,r.id from parcels_aggregate p inner join rights r ON p.right3 = r.description
order by lpi_code
)

select max(length(dam_no)) from dams_all_geo;
select dam_no from dams_all_geo WHERE length(dam_no) >7;

--loading SG data
--Admire prepped and loaded SG shapefiles from Nic

--Admire's ogr2ogr scripts to be pasted here:...


--Admire didn't set SRID, so:

--I got a list of sg tables into a text file and: 

 for table in `cat sg_tables`; do psql -d sg -c "select updategeometrysrid('$table','wkb_geometry','4148')"; done

--we want them in a separate schema so:

 for table in `cat sg_tables`; do psql -d sg -c "alter table $table set schema sg"; done

--tidying up
 insert into sg.proclamation_area (wkb_geometry,gid ,comments,tag_value,tag_just)
 (select wkb_geometry,gid ,comments,tag_value,tag_just from sg.proclammation_area);

drop table sg.proclammation_area;

alter table sg.international_boundary_ rename to international_boundary

insert into sg.other_boundaries (wkb_geometry,gid ,comments,tag_value,tag_just)
 (select wkb_geometry,gid ,comments,tag_value,tag_just from sg.other_boundaries_);

drop table sg.other_boundaries_;

SET search_path = sg, public;

alter table established_boundary alter column wkb_geometry set data type geometry(MultiLinestring,4148)

--adding table for final dams, removing extraneous dams
CREATE TABLE public.dwa_dams_final
(
   dam_no character varying(10)
) 
;

copy dwa_dams_final from '/data/KirchhoffSurveyors/dwa_dams_final';

DELETE FROM dams_all_geo WHERE gid NOT IN (SELECT gid FROM dams_all_geo a JOIN dwa_dams_final b USING (dam_no) ORDER BY gid);

--setting up default style for farm_portions

copy layer_styles from '/tmp/layerstyle.csv' with (format csv,header);

update layer_styles set f_table_catalog = 'dwaregister';

INSERT INTO layer_styles (f_table_catalog,f_table_schema,f_table_name,f_geometry_column,stylename,styleqml,stylesld,useasdefault,description,owner,update_time) VALUES (
'dwaregister','sg','farm_portion','geom','farm_portion',XMLPARSE (DOCUMENT '<!DOCTYPE qgis PUBLIC "http://mrcc.com/qgis.dtd" "SYSTEM">
<qgis version="2.5.0-Master" minimumScale="-4.65661e-10" maximumScale="500000" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="0" scaleBasedLabelVisibilityFlag="0">
 <renderer-v2 symbollevels="0" type="singleSymbol">
  <symbols>
   <symbol alpha="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0"/>
     <prop k="border_width_unit" v="MM"/>
     <prop k="color" v="172,142,191,255"/>
     <prop k="color_border" v="0,0,0,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="style" v="no"/>
     <prop k="style_border" v="solid"/>
     <prop k="width_border" v="0.26"/>
    </layer>
   </symbol>
  </symbols>
  <rotation/>
  <sizescale scalemethod="area"/>
 </renderer-v2>
 <customproperties>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitMinScale" value="0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitMaxScale" value="0"/>
  <property key="labeling/distMapUnitMinScale" value="0"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fontBold" value="true"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value="Ubuntu"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="11"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/fontSizeMapUnitMinScale" value="0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="63"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value="Medium"/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="1"/>
  <property key="labeling/placementFlags" value="0"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMaxScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMinScale" value="0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitMinScale" value="0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMinScale" value="0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMinScale" value="0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitMinScale" value="0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>id</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name="Ubuntu"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <edittypes>
  <edittype labelontop="0" editable="1" name="gid"/>
  <edittype labelontop="0" editable="1" name="__gid"/>
  <edittype labelontop="0" editable="1" name="prcl_key"/>
  <edittype labelontop="0" editable="1" name="prcl_type"/>
  <edittype labelontop="0" editable="1" name="lstatus"/>
  <edittype labelontop="0" editable="1" name="wstatus"/>
  <edittype labelontop="0" editable="1" name="geom_area"/>
  <edittype labelontop="0" editable="1" name="comments"/>
  <edittype labelontop="0" editable="1" name="tag_x"/>
  <edittype labelontop="0" editable="1" name="tag_y"/>
  <edittype labelontop="0" editable="1" name="tag_value"/>
  <edittype labelontop="0" editable="1" name="tag_size"/>
  <edittype labelontop="0" editable="1" name="tag_angle"/>
  <edittype labelontop="0" editable="1" name="tag_just"/>
  <edittype labelontop="0" editable="1" name="id"/>
  <edittype labelontop="0" editable="1" name="date_stamp"/>
 </edittypes>
 <editform></editform>
 <editforminit></editforminit>
 <featformsuppress>0</featformsuppress>
 <annotationform></annotationform>
 <editorlayout>generatedlayout</editorlayout>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
</qgis>'),
XMLPARSE (DOCUMENT '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>farm_portion</se:Name>
  <UserStyle>
   <se:Name>farm_portion</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>Single symbol</se:Name>
     <se:PolygonSymbolizer>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>'),'t','Sun Jul 6 16:23:38 2014','gavin','2014-07-06 14:23:38.9327'
);

SELECT f_table_catalog,f_table_schema,f_table_name,f_geometry_column,stylename,styleqml,stylesld,useasdefault,description,owner,update_time FROM layer_styles;
--I saved the styles as default styles locally again after setting postgresql config xmloption to document from content, after restore didn't work 
--in the end I backed up layer styles, restored it into the db as a temp file then transferred all the records across to layer_styles

ALTER TABLE purchase_plans_surveyed
  ADD COLUMN source character varying(255);
COMMENT ON COLUMN purchase_plans_surveyed.source IS 'note the source and original format of this feature';

ALTER TABLE purchase_plans_digitised RENAME validated_by  TO digitised_by;


ALTER TABLE purchase_plans_digitised
  ADD COLUMN comment character varying(255);

  ALTER TABLE purchase_plans_surveyed
  RENAME TO purchase_plans_external;

ALTER TABLE purchase_plans_final
   ADD COLUMN comment character varying(255);

   ALTER TABLE purchase_plans_digitised
   ADD COLUMN moved_to_final boolean NOT NULL DEFAULT FALSE;


SELECT id FROM sg.farm_portions lpi JOIN purchase_plans_digitised pp ON ST_Intersect(lpi.geom,pp.geom) WHERE ;


--move basemap layers to another schema
--DROP SCHEMA static;
CREATE SCHEMA project;
GRANT USAGE ON SCHEMA project TO editor;

set search_path to public; --project

--moved all project tables to project schema, leaving basemap / static tables in public
for table in `cat tables2schemaproject`; do psql -d dwaregister -c "alter table $table set schema project"; done

alter table project.dwafdams_capacity_sae set schema public;

ALTER TABLE project.parcel_description
  ADD COLUMN prev_parent_mnrcode integer;
ALTER TABLE project.parcel_description
  ADD CONSTRAINT parcel_description_prev_parent_mnrcode_fkey FOREIGN KEY (mnrcode) REFERENCES project.minor_codes (code)
   ON UPDATE NO ACTION ON DELETE NO ACTION;

   ALTER TABLE project.parcel_description
  ADD COLUMN prev_parent_farm_no integer;

  CREATE TABLE project.right_types
(
  id serial NOT NULL,
  right_type character varying NOT NULL,
  CONSTRAINT right_types_pkey PRIMARY KEY (id),
  CONSTRAINT right_types_code_key UNIQUE (right_type)
);
ALTER TABLE project.right_types
  OWNER TO gavin;
GRANT ALL ON TABLE project.right_types TO gavin;
GRANT SELECT ON TABLE project.right_types TO public;
GRANT SELECT, UPDATE, INSERT ON TABLE project.right_types TO editor;

insert into project.right_types (right_type) VALUES
('servitude'),
('lease');

ALTER TABLE project.rights
  ADD CONSTRAINT rights_right_types_fkey FOREIGN KEY (right_type) REFERENCES project.right_types (right_type)
   ON UPDATE NO ACTION ON DELETE NO ACTION;
CREATE INDEX fki_rights_right_types_fkey
  ON project.rights(right_type);

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE project.purchase_plans_digitised TO approval;

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE project.purchase_plans_final TO approval;