CREATE SCHEMA [db_denydatawriter];
GO

--************************************** [menu]

CREATE TABLE [deployments]
(
 [id]              INT NOT NULL ,
 [start]           DATE NOT NULL ,
 [end]             DATE NOT NULL ,
 [started_by]      TEXT,
 [result]          INT NOT NULL DEFAULT 0,
 [notes]           TEXT,  

 CONSTRAINT [PK_deployment] PRIMARY KEY  ([id] ASC)
 CONSTRAINT [FK_result]  FOREIGN KEY  ([result]
 	    REFERENCES [deployment_result][id])
);
GO

-- State -1 == projected
CREATE TABLE [deployment_state]
(
 [id]              INT NOT NULL ,
 [description]     TEXT NOT NULL ,
 
 CONSTRAINT [PK_deployment_result] PRIMARY KEY  ([id] ASC)
);
GO


