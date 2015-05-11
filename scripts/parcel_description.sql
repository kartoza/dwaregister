-- Table: project.parcel_description

-- DROP TABLE project.parcel_description;

CREATE TABLE project.parcel_description
(
  file_no character varying,
  sg_off_name character varying,
  id serial NOT NULL,
  diagram_no character varying(20), -- e.g. A2256/1969
  description character varying(255), -- new or current description e.g. 221/376-IQ
  description_old character varying, -- old description e.g.
  crs integer,
  area double precision, -- area written on survey diagram
  area_unit character varying(13), -- the unit of the area on the plan - must come from a lookup table
  deed_no character varying, -- deed number e.g. 102/70
  parent character varying, -- parent diagram number e.g. ?
  compilation character varying, -- e.g. IQ5A-13
  date_survey date, -- date of survey e.g. 3-1969
  notes character varying(255), -- notes on back page referring to subdivisions and servitudes
  kode integer, -- Kirchhoff unique barcode number
  sg_off_code character varying(2),
  mjrcode character varying(3),
  mnrcode character varying(4),
  farm_no integer,
  portion integer,
  prev_parent_portion character varying,
  remainder character varying(20),
  sg_town_code character varying(20),
  lpi_code character varying(21),
  registered_owner character varying(255),
  province character varying(30),
  mag_district character varying(50),
  reg_division character varying(2),
  deed_office character varying(30),
  compilation_new character varying,
  town character varying(50),
  farm_name character varying(50),
  scheme_name character varying(50),
  scheme_ref_num character varying(50),
  captured_by character varying(50) DEFAULT "current_user"(),
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
  lease_obj_key character varying,
  servitude_obj_key character varying,
  usage_purpose character varying,
  unit character varying(16),
  prev_parent_mnrcode integer,
  prev_parent_farm_no integer,
  to_replace boolean,
  CONSTRAINT parcel_description_pkey PRIMARY KEY (id),
  CONSTRAINT parcel_description_area_unit_fkey FOREIGN KEY (unit)
      REFERENCES project.units (unit) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT parcel_description_crs_fkey FOREIGN KEY (crs)
      REFERENCES spatial_ref_sys (srid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_mjrcode_fkey FOREIGN KEY (mjrcode)
      REFERENCES project.major_codes (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_mnrcode_fkey FOREIGN KEY (mnrcode)
      REFERENCES project.minor_codes (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT parcel_description_province_fkey FOREIGN KEY (province)
      REFERENCES project.sg_province (province) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_region_fkey FOREIGN KEY (region)
      REFERENCES project.regions (region_code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_sg_off_code_fkey FOREIGN KEY (sg_off_code)
      REFERENCES project.sg_office_codes (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_sg_off_name_fkey FOREIGN KEY (sg_off_name)
      REFERENCES project.sg_offices (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_unit_fkey FOREIGN KEY (unit)
      REFERENCES project.units (unit) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT parcel_description_diagram_no_province_key UNIQUE (diagram_no, province),
  CONSTRAINT parcel_description_lpi_code_key UNIQUE (lpi_code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE project.parcel_description
  OWNER TO gavin;
COMMENT ON COLUMN project.parcel_description.diagram_no IS 'e.g. A2256/1969';
COMMENT ON COLUMN project.parcel_description.description IS 'new or current description e.g. 221/376-IQ';
COMMENT ON COLUMN project.parcel_description.description_old IS 'old description e.g. ';
COMMENT ON COLUMN project.parcel_description.area IS 'area written on survey diagram';
COMMENT ON COLUMN project.parcel_description.area_unit IS 'the unit of the area on the plan - must come from a lookup table';
COMMENT ON COLUMN project.parcel_description.deed_no IS 'deed number e.g. 102/70';
COMMENT ON COLUMN project.parcel_description.parent IS 'parent diagram number e.g. ?';
COMMENT ON COLUMN project.parcel_description.compilation IS 'e.g. IQ5A-13';
COMMENT ON COLUMN project.parcel_description.date_survey IS 'date of survey e.g. 3-1969';
COMMENT ON COLUMN project.parcel_description.notes IS 'notes on back page referring to subdivisions and servitudes';
COMMENT ON COLUMN project.parcel_description.kode IS 'Kirchhoff unique barcode number';


-- Index: project.fki_parc_desc_sg_off_code_sg_office_code

-- DROP INDEX project.fki_parc_desc_sg_off_code_sg_office_code;

CREATE INDEX fki_parc_desc_sg_off_code_sg_office_code
  ON project.parcel_description
  USING btree
  (sg_off_code COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_crs

-- DROP INDEX project.fki_parcel_description_crs;

CREATE INDEX fki_parcel_description_crs
  ON project.parcel_description
  USING btree
  (crs);

-- Index: project.fki_parcel_description_mag_district

-- DROP INDEX project.fki_parcel_description_mag_district;

CREATE INDEX fki_parcel_description_mag_district
  ON project.parcel_description
  USING btree
  (mag_district COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_mjrcode

-- DROP INDEX project.fki_parcel_description_mjrcode;

CREATE INDEX fki_parcel_description_mjrcode
  ON project.parcel_description
  USING btree
  (mjrcode COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_mnrcode

-- DROP INDEX project.fki_parcel_description_mnrcode;

CREATE INDEX fki_parcel_description_mnrcode
  ON project.parcel_description
  USING btree
  (mnrcode COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_mnrcode_fkey

-- DROP INDEX project.fki_parcel_description_mnrcode_fkey;

CREATE INDEX fki_parcel_description_mnrcode_fkey
  ON project.parcel_description
  USING btree
  (mnrcode COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_region_code

-- DROP INDEX project.fki_parcel_description_region_code;

CREATE INDEX fki_parcel_description_region_code
  ON project.parcel_description
  USING btree
  (region COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_sg_office

-- DROP INDEX project.fki_parcel_description_sg_office;

CREATE INDEX fki_parcel_description_sg_office
  ON project.parcel_description
  USING btree
  (sg_off_name COLLATE pg_catalog."default");

-- Index: project.fki_parcel_description_sg_office_code

-- DROP INDEX project.fki_parcel_description_sg_office_code;

CREATE INDEX fki_parcel_description_sg_office_code
  ON project.parcel_description
  USING btree
  (sg_off_code COLLATE pg_catalog."default");

-- Index: project.fki_regions_province

-- DROP INDEX project.fki_regions_province;

CREATE INDEX fki_regions_province
  ON project.parcel_description
  USING btree
  (province COLLATE pg_catalog."default");

-- Index: project.parcel_description_units

-- DROP INDEX project.parcel_description_units;

CREATE INDEX parcel_description_units
  ON project.parcel_description
  USING btree
  (unit COLLATE pg_catalog."default");

