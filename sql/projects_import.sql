COPY lcm_projects FROM LOCAL '/Users/tomaskorcak/dev/gooddata-lcm-training/data/projects.csv'
  WITH PARSER GDCCSVParser()
  DELIMITER ','
  NULL AS ''
  ESCAPE AS '"'
  ENCLOSED BY '"'
  SKIP 1
  EXCEPTIONS '/tmp/projects.exceptions.log'
  REJECTED DATA '/tmp/projects.rejected.log'
  DIRECT;
