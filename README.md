# HRMS (Human Resource Management System)
### PostgreSQL - Database
### Build with <a href="https://github.com/eomeracar">Omer Acar<a> and <a href="https://github.com/ugurryildiz">Ugur Yildiz</a>

# Structure Explanation
 - <b style="font-size:18px"><u>users</u></b> (<i><b>en</b>: base table for all user types | <b>tr</b>: tüm kullanıcı türleri için ana tablo</i>)
    - <b style="font-size:18px"><u>candidates</u></b> (<i><b>en</b>: job seekers | <b>tr</b>: iş arayanlar </i>)
    - <b style="font-size:18px"><u>employers</u></b> (<i><b>en</b>: employers for job seekers | <b>tr</b>: iş verenler </i>)
    - <b style="font-size:18px"><u>employees</u></b> (<i><b>en</b>: hrms system staff | <b>tr</b>: hrms sistem çalışanları</i>)
    - <b style="font-size:18px"><u>user_phones</u></b> (<i><b>en</b>: user phones | <b>tr</b>: kullanıcı telefonları</i>)
    - <b style="font-size:18px"><u>user_verifications</u></b> (<i><b>en</b>: user verifications | <b>tr</b>: kullanıcıların doğrulamaları</i>)
    - <b style="font-size:18px"><u>user_confirms</u></b> (<i><b>en</b>: user confirms | <b>tr</b>: kullanıcıların onaylanmaları</i>)
 - <b style="font-size:18px"><u>countries</u></b> (<i><b>en</b>: all countries of world | <b>tr</b>: dünyada ki tüm ülkeler</i>)
   - <b style="font-size:18px"><u>states</u></b> (<i><b>en</b>: all states of countries | <b>tr</b>: ülkere ait eyalet ve iller</i>)
     - <b style="font-size:18px"><u>cities</u></b> (<i><b>en</b>: all cities of states | <b>tr</b>: eyalet ve illere ait ilçeler</i>)
 - <b style="font-size:18px"><u>jobs</u></b> (<i><b>en</b>: advertisements for jobs | <b>tr</b>: iş ilanları</i>)
 - <b style="font-size:18px"><u>job_titles</u></b> (<i><b>en</b>: official job titles | <b>tr</b>: kurumsal mesleki ünvanlar </i>)
 - <b style="font-size:18px"><u>website_types</u></b> (<i><b>en</b>: types for websites(social, blog etc.) | <b>tr</b>: web adresleri için tipler(sosyal medya,blog vs.)</i>)
 - <b style="font-size:18px"><u>qualifications</u></b> (<i><b>en</b>: definitions for all qualifications | <b>tr</b>: yetenek/nitelikler için tanımlamalar</i>)
 - <b style="font-size:18px"><u>resumes</u></b> (<i><b>en</b>: curriculum vitaes of users | <b>tr</b>: kullanıcı özgeçmişleri</i>)
     - <b style="font-size:18px"><u>resume_websites</u></b> (<i><b>en</b>: websites of resume | <b>tr</b>: cv'ye ait web adresleri</i>)
     - <b style="font-size:18px"><u>resume_experiences</u></b> (<i><b>en</b>: job experiences of resume | <b>tr</b>: cv'ye ait iş tecrübeleri</i>)
     - <b style="font-size:18px"><u>resume_educations</u></b> (<i><b>en</b>: educations of resume | <b>tr</b>: cv'ye ait eğitim geçmişi</i>)
     - <b style="font-size:18px"><u>resume_languages</u></b> (<i><b>en</b>: languages of resume | <b>tr</b>: cv'ye ait bildiği diller</i>)
     - <b style="font-size:18px"><u>resume_qualifications</u></b> (<i><b>en</b>: qualifications of resume | <b>tr</b>: cv'ye ait nitelik ve yetenekler</i>)

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
### ER Diagram with DBEaver
<p align="center"><img src="images/ER Diagram-postgresql-2.png"></p>
