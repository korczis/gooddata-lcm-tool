COPY lcm_users FROM LOCAL '/Users/tomaskorcak/dev/gooddata-lcm-training/data/users.csv'
  WITH PARSER GDCCSVParser()
  DELIMITER ','
  NULL AS ''
  ESCAPE AS '"'
  ENCLOSED BY '"'
  SKIP 1
  EXCEPTIONS '/tmp/users.exceptions.log'
  REJECTED DATA '/tmp/users.rejected.log'
  DIRECT;
