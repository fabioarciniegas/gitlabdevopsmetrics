DROP TABLE deployments;
DROP TABLE deployment_state;

-- State -1 == projected
CREATE TABLE deployment_states
(
 id              INT NOT NULL,
 description     TEXT NOT NULL ,
 
 CONSTRAINT PK_deployment_result PRIMARY KEY  (id ASC)
);


CREATE TABLE deployments
(
 id              INT NOT NULL AUTO_INCREMENT,
 start           DATETIME NOT NULL,
 end             DATETIME NOT NULL,
 result          INT NOT NULL DEFAULT -1,
 started_by      TEXT,
 notes           TEXT,  

 CONSTRAINT PK_deployment PRIMARY KEY  (id ASC),
 CONSTRAINT FK_result  FOREIGN KEY  (result) REFERENCES deployment_states(id)
);

INSERT INTO deployment_states (id,description) values (-1,"Projected, not actual");
INSERT INTO deployment_states (id,description) values (0,"Success");
INSERT INTO deployment_states (id,description) values (1,"Failure");


-- TODO: make this independent of path
LOAD DATA INFILE 'test_data_generator.csv' INTO TABLE devsecops_soc.deployments  FIELDS TERMINATED BY ',' 

