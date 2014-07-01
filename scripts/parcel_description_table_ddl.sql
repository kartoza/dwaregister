-- Table: survey

CREATE TABLE parcel_description
(
  file_no character varying,
  sg_off_name character varying,
  id serial NOT NULL,
  diagram_no character varying(20) NOT NULL, -- e.g. A2256/69
  description character varying(255), -- new or current description e.g. 221/376-IQ
  description_old character varying, -- old description e.g.
  unit integer NOT NULL,
  crs integer NOT NULL,
  area double precision, -- area written on survey diagram
  area_unit character varying(5), -- the unit of the area on the plan - must come from a lookup table
  deed_no character varying, -- deed number e.g. 102/70
  parent character varying, -- parent diagram number e.g. ?
  compilation character varying, -- e.g. IQ5A-13
  date_survey date, -- date of survey e.g. 3-1969
  notes character varying(255), -- notes on back page referring to subdivisions and servitudes
  kode integer, -- Kirchhoff unique barcode number
  sg_off_code character varying(2),
mjrcode character varying(4),
mnrcode integer,
farm_no integer,
portion integer, 
prev_parent_portion integer,
remainder character varying(20),
sg_town_code character varying(20),
lpi_code character varying(21),
registered_owner character varying(255),
province character varying(30),
mag_district character varying(50),
reg_division character varying(2),
deed_office character varying(30),
compilation_new character varying(20),
town character varying(50),
farm_name character varying(50),
qds  character varying(6),
right_type  character varying(50),
scheme_name  character varying(50),
scheme_ref_num  character varying(50),
captured_by  character varying(50),
cluster character varying,
region character varying,
allotment_region_name character varying,
capture_timestamp timestamp without time zone DEFAULT now(),
dwa_allocation character varying,
dwa_legal_status character varying,
dgm_valid_from date,
dgm_valid_to date,
registration_date date,
sale_price integer,
ownership_share double precision,
lease_obj_key  character varying,
servitude_obj_key character varying,
usage_purpose character varying,
dam_no character varying (10),

  CONSTRAINT parcel_description_pkey PRIMARY KEY (id),
  CONSTRAINT parcel_description_diagram_no_key UNIQUE (diagram_no));
ALTER TABLE parcel_description
  OWNER TO gavin;
GRANT ALL ON TABLE parcel_description TO gavin;
GRANT SELECT ON TABLE parcel_description TO editor;


COMMENT ON COLUMN parcel_description.diagram_no IS 'e.g. A2256/69';
COMMENT ON COLUMN parcel_description.description IS 'new or current description e.g. 221/376-IQ';
COMMENT ON COLUMN parcel_description.description_old IS 'old description e.g. ';
COMMENT ON COLUMN parcel_description.area IS 'area written on survey diagram';
COMMENT ON COLUMN parcel_description.area_unit IS 'the unit of the area on the plan - must come from a lookup table';
COMMENT ON COLUMN parcel_description.deed_no IS 'deed number e.g. 102/70';
COMMENT ON COLUMN parcel_description.parent IS 'parent diagram number e.g. ?';
COMMENT ON COLUMN parcel_description.compilation IS 'e.g. IQ5A-13';
COMMENT ON COLUMN parcel_description.date_survey IS 'date of survey e.g. 3-1969';
COMMENT ON COLUMN parcel_description.notes IS 'notes on back page referring to subdivisions and servitudes';
COMMENT ON COLUMN parcel_description.kode IS 'Kirchhoff unique barcode number';


