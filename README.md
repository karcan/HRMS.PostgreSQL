# HRMS (Human Resource Management System)
### PostgreSQL - Database
### <a href="database.sql">Click</a> for script codes.
* * *

### Tablo yapısı:
- <b>users</b> (<i>tüm kullanıcı türlerini saklayacağımız ana tablomuz</i>)
	- <b>candidates</b> (<i>iş arayan kullanıcılar</i>)
	- <b>employees</b>  (<i>sistem çalışanları</i>) 
	- <b>employers</b> (<i>iş veren kullanıcılar</i>)
	  - <b>employer_phones</b> (<i>iş verenlerin birden fazla telefonu olabileceği için ek bir tablo</i>)   
- <b>verification_codes</b> (<i>doğrulama sistemlerimiz için doğrulama kodlarını tutacağımız ana tablomuz</i>)
	- <b>verification_codes_candidates</b>  (<i>iş arayan kullanıcılar için kod ile doğrulama yapmak için tablomuz</i>)
	- <b>verification_codes_employers</b> (<i>iş veren kullanıcılar için kod ile doğrulama yapmak için tablomuz</i>)
- <b>employee_confirms</b> (<i>sistem çalışanlarının onaylama yapabilmesi için ana tablomuz</i>)
	- <b>employee_confirms_employers</b>  (<i>sistem çalışanlarının, iş verenlerini onaylayacağı tablo.</i>)
- <b>job_titles</b> (<i>iş pozisyonlarının isimlerini tutacağımız tablomuz.</i>)

### Doğrulamalar:
- users (<i>email_address ve password  unique constraint ile zorunlu hale getirildi.</i>)
- candidates (<i>first_name, last_name, identification_number ve birth_date unique constraint ile zorunlu hale getirildi.</i>)
- employers (<i>company_name, web_address ve phone_number  unique constraint ile  ile zorunlu hale getirildi.</i>)

### Kurallar:
- employers (<i>web_address alanının users tablosunda ki email_address ile uyumlu olup olmadığı check constraint ile kontrol edilir hale getirildi.</i>)


<!--
### Relation descriptions : 
  - <b>users</b> <i>(all types of users.)</i>
    - <b>candidates</b> <i>(job seekers)</i>
    - <b>employees</b> <i>(hrms system workers)</i>
    - <b>employers</b> <i>(employers for candidates)</i>
      - <b>employer_activation_by_employees</b> <i>(employers activation method by employees)</i>
  - <b>activation_codes</b> <i>(base table for all activation methods with activation code)</i>
    - <b>activation_code_to_employers</b> <i>(employers acivation method with activation code)</i>
    - <b>activation_code_to_candidates</b> <i>(candidates acivation method with activation code)</i>
  - <b>job_titles</b> <i>(job titles for job positions)</i>
  - -->
* * *
### ER Diagram with DrawSQL
<p align="center"><img src="images/ER Diagram.drawsql.2.png"></p>
