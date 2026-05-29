10-07-2022

https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04-es


https://ostechnix.com/fix-mysql-error-1819-hy000-your-password-does-not-satisfy-the-current-policy-requirements/

|low or 0|
SET GLOBAL validate_password.policy=LOW;
create user 'userapp'@'localhost' identified by 'password@123';

|mid or 1|
SET GLOBAL validate_password.policy=1;




_____________________________________________

https://platzi.com/tutoriales/1566-bd/8226-como-instalar-mysql-y-workbench-en-ubuntu-sin-morir-en-el-intento/
instalar workbench



https://www.ingenieriazeros.com/2020/06/solucion-workbench-ubuntu-AppArmor.html



select date_devanado , 
MAX(col1_val) AS 'max_col11', MAX(col1_val)/100 - LEAD(MAX(col1_val)/100,1,0) OVER (  ORDER BY date_devanado DESC) AS 'dif11',MAX(col2_val) AS 'max_col12', MAX(col2_val)/100 - LEAD(MAX(col2_val)/100,1,0) OVER (  ORDER BY date_devanado DESC) AS 'dif12' ,MAX(col3_val) AS 'max_col13', MAX(col3_val)/100 - LEAD(MAX(col3_val)/100,1,0) OVER (  ORDER BY date_devanado DESC) AS 'dif13' 
FROM `devanado_details` 
INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` 
INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id`
WHERE (devanado_flow_id = 1)AND transformer_id = 6 GROUP BY `devanado_details`.`date_devanado`
 

CREATE view view_devanado_details_by_devanado_flow_id_1 AS
select transformers.id as transformer_id,
devanado_details.devanado_id as devanado_id,
devanado_details.date_devanado,
MAX(col1_val) AS "max_at_1", MAX(col1_val)/100 - LEAD(MAX(col1_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS "dif_at_1",
MAX(col2_val) AS 'max_at_2', MAX(col2_val)/100 - LEAD(MAX(col2_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_at_2',
MAX(col3_val) AS 'max_at_3', MAX(col3_val)/100 - LEAD(MAX(col3_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_at_3' 
FROM `devanado_details` 
INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` 
INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id`
WHERE (devanado_flow_id = 1) 
GROUP BY `devanado_details`.`date_devanado`, `devanado_details`.`devanado_id` , `transformers`.`id`;

CREATE view view_devanado_details_by_devanado_flow_id_2 AS
select transformers.id as transformer_id,
devanado_details.devanado_id as devanado_id,
devanado_details.date_devanado,
MAX(col1_val) AS "max_bt1_1", MAX(col1_val)/100 - LEAD(MAX(col1_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS "dif_bt1_1",
MAX(col2_val) AS 'max_bt1_2', MAX(col2_val)/100 - LEAD(MAX(col2_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt1_2',
MAX(col3_val) AS 'max_bt1_3', MAX(col3_val)/100 - LEAD(MAX(col3_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt1_3' 
FROM `devanado_details` 
INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` 
INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id`
WHERE (devanado_flow_id = 2) 
GROUP BY `devanado_details`.`date_devanado`, `devanado_details`.`devanado_id` , `transformers`.`id`;


CREATE view view_devanado_details_by_devanado_flow_id_3 AS
select transformers.id as transformer_id,
devanado_details.devanado_id as devanado_id,
devanado_details.date_devanado,
MAX(col1_val) AS "max_bt2_1", MAX(col1_val)/100 - LEAD(MAX(col1_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS "dif_bt2_1",
MAX(col2_val) AS 'max_bt2_2', MAX(col2_val)/100 - LEAD(MAX(col2_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt2_2',
MAX(col3_val) AS 'max_bt2_3', MAX(col3_val)/100 - LEAD(MAX(col3_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt2_3' 
FROM `devanado_details` 
INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` 
INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id`
WHERE (devanado_flow_id = 3) 
GROUP BY `devanado_details`.`date_devanado`, `devanado_details`.`devanado_id` , `transformers`.`id`;


CREATE view view_devanado_details_by_devanado_flow_id_4 AS
select transformers.id as transformer_id,
devanado_details.devanado_id as devanado_id,
devanado_details.date_devanado,
MAX(col1_val) AS "max_bt3_1", MAX(col1_val)/100 - LEAD(MAX(col1_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS "dif_bt3_1",
MAX(col2_val) AS 'max_bt3_2', MAX(col2_val)/100 - LEAD(MAX(col2_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt3_2',
MAX(col3_val) AS 'max_bt3_3', MAX(col3_val)/100 - LEAD(MAX(col3_val)/100,1,0) OVER (ORDER BY date_devanado DESC) AS 'dif_bt3_3' 
FROM `devanado_details` 
INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` 
INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id`
WHERE (devanado_flow_id = 4) 
GROUP BY `devanado_details`.`date_devanado`, `devanado_details`.`devanado_id` , `transformers`.`id`;


SELECT  
 view_devanado_details_by_devanado_flow_id_1.transformer_id,
 view_devanado_details_by_devanado_flow_id_1.devanado_id,
 view_devanado_details_by_devanado_flow_id_1.date_devanado,
 max_at_1,dif_at_1, max_at_2,dif_at_2, max_at_3,dif_at_3,
 max_bt1_1,dif_bt1_1, max_bt1_2,dif_bt1_2, max_bt1_3,dif_bt1_3,
 max_bt2_1,dif_bt2_1, max_bt2_2,dif_bt2_2, max_bt2_3,dif_bt2_3,
 max_bt3_1,dif_bt3_1, max_bt3_2,dif_bt3_2, max_bt3_3,dif_bt3_3

FROM  view_devanado_details_by_devanado_flow_id_1
INNER JOIN view_devanado_details_by_devanado_flow_id_2 ON view_devanado_details_by_devanado_flow_id_2.date_devanado =view_devanado_details_by_devanado_flow_id_1.date_devanado
INNER JOIN view_devanado_details_by_devanado_flow_id_3 ON view_devanado_details_by_devanado_flow_id_3.date_devanado =view_devanado_details_by_devanado_flow_id_1.date_devanado
INNER JOIN view_devanado_details_by_devanado_flow_id_4 ON view_devanado_details_by_devanado_flow_id_4.date_devanado =view_devanado_details_by_devanado_flow_id_1.date_devanado


_____________________________

SELECT `devanado_id`,`devanado_flow_id`,`date_devanado` ,`col1_val` FROM `devanado_details` INNER JOIN `devanados` ON `devanados`.`id` = `devanado_details`.`devanado_id` INNER JOIN `transformers` ON `transformers`.`id` = `devanados`.`transformer_id` WHERE (devanado_flow_id = 1)AND transformer_id = 75 AND `date_devanado` = "2021-09-24"