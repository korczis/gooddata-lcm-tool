COPY lcm_release FROM LOCAL '/Users/tomaskorcak/dev/gooddata-lcm-training/data/releases.csv'
  WITH PARSER GDCCSVParser()
  DELIMITER ','
  NULL AS ''
  ESCAPE AS '"'
  ENCLOSED BY '"'
  SKIP 1
  EXCEPTIONS '/tmp/users.exceptions.log'
  REJECTED DATA '/tmp/users.rejected.log'
  DIRECT;
