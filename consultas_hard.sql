/* Mostre anos de nascimento �nicos de pacientes e ordene-os em ordem crescente. */
select 
	distinct year (birth_date)
from patients
order by birth_date asc

/*Mostra nomes �nicos da tabela de pacientes que ocorrem apenas uma vez na lista.
Por exemplo, se duas ou mais pessoas tiverem o nome 'John' na coluna first_name,
n�o inclua seus nomes na lista de sa�da. Se apenas 1 pessoa for chamada de 'Leo',
inclua-a na sa�da.*/
select 
	first_name
from patients
group by first_name
having
	count (first_name) = 1

/*Mostra o Patient_id e o first_name dos pacientes onde o first_name come�a e
termina com 's' e tem pelo menos 6 caracteres.*/
select patient_id, first_name
from patients
where first_name like 's____%s'


/*Mostra o Patient_id, first_name, last_name de pacientes cujo diagn�stico � 
'Dementia'.O diagn�stico prim�rio � armazenado na tabela de admiss�es.*/
select 
	patients.patient_id, 
    first_name, 
    last_name
from patients
join admissions 
	on patients.patient_id = admissions.patient_id
where diagnosis = 'Dementia'


/*Exibe o nome de cada paciente.
Ordene a lista pelo comprimento de cada nome e depois por ordem alfab�tica*/
select first_name 
from patients
order by 
	len(first_name),
	first_name


/*Mostre a quantidade total de pacientes do sexo masculino e a quantidade total 
de pacientes do sexo feminino na tabela de pacientes.
Exiba os dois resultados na mesma linha.*/
select
	(select count(*)  from patients where gender = 'M') as totalM,
    (select count(*)  from patients where gender = 'F') as totalF
    

/*Mostrar nome e sobrenome, alergias de pacientes que t�m alergia a 'Penicillin' 
ou 'Morphine'. Mostrar resultados ordenados por alergias, depois por first_name
e por last_name.*/    
select 
	first_name, 
    last_name, 
    allergies
from patients
where 
	allergies = 'Morphine' OR allergies = 'Penicillin'
order by 
	allergies , 
    first_name,
    last_name   
    

/*Mostra o ID do paciente, diagn�stico das admiss�es. Encontre pacientes 
admitidos v�rias vezes para o mesmo diagn�stico.*/    
select 
	patient_id, 
    diagnosis
from admissions
group by 
	patient_id,
    diagnosis
having count (*) >1
    
    
/*Mostra a cidade e o n�mero total de pacientes na cidade.
Ordene de mais para menos pacientes e, em seguida, pelo nome da cidade em 
ordem crescente.*/   
select 
	city, 
    count (patient_id)  AS total_pacientes
from patients
group by 
	city
order by 
	total_pacientes desc, 
    city


/*Mostre o nome, o sobrenome e a fun��o de cada pessoa que � paciente ou m�dico.
As fun��es s�o "pacientes" ou "Doctor"*/
select 
	first_name, 
    last_name , 
    'pacientes' as funcao  from patients
union all 
select 
	first_name, 
    last_name ,
    'medico'  from patients


/*Mostrar todas as alergias ordenadas por popularidade. Remova os valores 
NULL da consulta.*/
select 
	allergies 
    , count (patient_id) as total_diag
from patients
where 
	allergies is not null
group by allergies 
order by total_diag desc


/*Mostre o nome, sobrenome e data de nascimento de todos os pacientes que 
nasceram na d�cada de 1970. Classifique a lista a partir da data de nascimento
mais antiga.*/
select 
	first_name, 
    last_name, 
    birth_date
from patients
where 
	year(birth_date) like '197%'
order by birth_date 
    
/*Queremos exibir o nome completo de cada paciente em uma �nica coluna. 
Seu sobrenome em letras mai�sculas deve aparecer primeiro, depois o primeiro nome 
em letras min�sculas. 
Separe o last_name e o first_name com uma v�rgula. 
Ordene a lista pelo first_name em ordem decrescente
EX: SMITH,jane*/    
select 
	concat ( upper( last_name), ',',lower( first_name)) as nome_completo
from patients
order by first_name desc


/*Mostrar o(s) province_id(s), soma da altura; onde a soma total da altura 
de seu paciente � maior ou igual a 7.000.*/
select 
	province_id, 
    sum(height)
from patients
group by province_id
having  
	sum(height) >= 7000


/*Mostrar a diferen�a entre o maior peso e o menor peso para pacientes com 
o sobrenome 'Maroni'*/
select( max(weight) - min(weight)) as diferenca
from patients
where last_name = 'Maroni'


/*Mostra todos os dias do m�s (1-31) e quantas datas de admiss�o ocorreram 
naquele dia. 
Classifique pelo dia com mais admiss�es para menos admiss�es.*/
select 
	day(admission_date) as dias, 
    count (admission_date) AS registros
from admissions
group by dias
order by registros desc


/*Mostra todas as colunas para a data de admiss�o mais recente do 
Patient_id 542.*/
select * 
from admissions
where patient_id = 542 
group by patient_id
having 
	admission_date = max(admission_date)


/*Mostre o Patient_id, attending_doctor_id e o diagn�stico para admiss�es que
correspondam a um dos dois crit�rios:
1. Patient_id � um n�mero �mpar e Attend_doctor_id � 1, 5 ou 19.
2. Attend_doctor_id cont�m um 2 e o comprimento de Patient_id � 3 caracteres*/
SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  )


/*Mostra first_name, last_name e o n�mero total de interna��es atendidas 
por cada m�dico.
Cada interna��o foi acompanhada por um m�dico.*/
select 
	first_name, 
    last_name, 
    count( attending_doctor_id) as atendimento_total
from admissions as adm
join doctors as doc 
	on adm.attending_doctor_id = doc.doctor_id
group by first_name


/*Para cada m�dico, exiba sua identifica��o, nome completo e a primeira e a 
�ltima data de interna��o em que compareceram.*/
select 
	doctor_id,
	concat(ph.first_name,' ', ph.last_name) as nome_completo,
    min( admission_date),
    max( admission_date)
from doctors as ph
join admissions as adm on ph.doctor_id = adm.attending_doctor_id
group by nome_completo


/*Exiba a quantidade total de pacientes para cada prov�ncia. 
Ordem decrescente.*/
select 
	province_name, 
	count(patient_id) as total_pacientes
from province_names as pn
join patients on pn.province_id = patients.province_id
group by province_name 
order by total_pacientes desc


/*Para cada admiss�o, exiba o nome completo do paciente, o diagn�stico de 
admiss�o e o nome completo do m�dico que diagnosticou o problema.*/
select 
	concat (pat.first_name,' ', pat.last_name) as nome_paciente
    , diagnosis 
	,concat (ph.first_name,' ', ph.last_name) as nome_medico
from patients as pat
join admissions	 as adm on pat.patient_id = adm.patient_id
join doctors as ph on ph.doctor_id = adm.attending_doctor_id


/*exibir o n�mero de pacientes duplicados com base em seu nome e sobrenome.*/
select
	count(*) as nomes_duplicados, 	 
	first_name,
    last_name
from patients 
group by 
	first_name,
    last_name
having count(*)  = 2



/*----------------------*/
/*Mostre todos os pacientes agrupados em grupos de peso.
Mostre a quantidade total de pacientes em cada grupo de peso.
Ordene a lista pelo grupo de peso decrescente.
Por exemplo, se eles pesam de 100 a 109, eles s�o colocados no grupo de peso 
100, 110-119 = grupo de peso 110, etc.*/
select count(*) as total_pacientes,
	floor (weight/10) * 10 as grupos_peso
from patients
group by grupos_peso
order by grupos_peso desc

/*solucao alternativa*/
SELECT
  count(patient_id),
  weight - weight % 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC


/*Mostre o ID_do_paciente, peso, altura, isObeso da tabela de pacientes.
Exibe isObese como booleano 0 ou 1.
Obeso � definido como peso(kg)/(altura(m) ^2 ) >= 30.
o peso est� em unidades kg.
a altura est� em unidades cm.*/

select patient_id, weight, height,
	case 
    	WHEN (weight / power( height/100.0, 2)) >= 30 THEN 1
        ELSE 0
        END '� OBSO'
from patients


/*Mostra o Patient_id, first_name, last_name e a especialidade do m�dico.
Mostrar apenas os pacientes com diagn�stico de 'Epilepsy' e o primeiro nome 
do m�dico � 'Lisa'
Verifique as tabelas de pacientes, interna��es e m�dicos para obter as informa��es necess�rias.*/

select 
	PAT.patient_id, 
    PAT.first_name, 
    PAT.last_name, 
    specialty
from patients as PAT
join 
	admissions as ADM on  PAT.patient_id = ADM.patient_id
join 
	doctors AS PH ON ADM.attending_doctor_id = PH.doctor_id
where 
	diagnosis  = 'Epilepsy' 
    AND 
    PH.first_name = 'Lisa'


/*Todos os pacientes que passaram por interna��es, podem consultar seus 
documentos m�dicos em nosso site. Esses pacientes recebem uma senha tempor�ria 
ap�s sua primeira admiss�o. Mostre o Patient_id e temp_password.
A senha deve ser a seguinte, em ordem:
1. ID_do_paciente
2. Comprimento num�rico do sobrenome do paciente
3. Ano da data_de_nascimento do paciente*/

select 
	patients.patient_id,
    concat(patients.patient_id,len( last_name),year(birth_date)) AS SENHA
from patients
join admissions ON patients.patient_id = admissions.patient_id
group by patients.patient_id

/*Cada admiss�o custa $ 50 para pacientes sem seguro e $ 10 para pacientes com 
seguro. Todos os pacientes com um ID de paciente par t�m seguro.
D� a cada paciente um 'Sim' se tiver seguro e um 'N�o' se n�o tiver seguro. 
Some o custo admiss�o_total para cada grupo has_insurance.*/

select 
case
	when patient_id % 2 = 0 THEN 'YES'
    ELSE 'NO'
    END 'TEM_SEGUTO?',
case
	WHEN patient_id % 2 = 0 THEN count(patient_id) * 10
    ELSE count(patient_id) * 50
    END 'TOTALPRECO'
from admissions
group by patient_id % 2 = 0

/* Solu��o Alternativa*/
SELECT 
CASE 
	WHEN patient_id % 2 = 0 Then 'Yes'
	ELSE 'No' 
	END as has_insurance,
SUM(
  CASE 
  	WHEN patient_id % 2 = 0 Then 10
	ELSE 50 
	END) as cost_after_insurance
FROM admissions 
GROUP BY has_insurance;

/*Mostre as prov�ncias que t�m mais pacientes identificados como 'M' do que 
como 'F'. Deve mostrar apenas o nome_prov�ncia completo*/

select province_name
from province_names as NP
join patients AS PAT 
	ON PAT.province_id = NP.province_id
group by province_name
having 
	count( case WHEN gender = 'M' THEN 1 END) > 
    count ( case WHEN gender = 'F' THEN 1 END)

/*SOLU�AO ALTERNATIVA*/
SELECT province_name
FROM (
    SELECT
      province_name,
      SUM(gender = 'M') AS n_male,
      SUM(gender = 'F') AS n_female
    FROM patients pa
      JOIN province_names pr ON pa.province_id = pr.province_id
    GROUP BY province_name
  )
WHERE n_male > n_female

/*Estamos procurando um paciente espec�fico. Puxe todas as colunas para o 
paciente que corresponde aos seguintes crit�rios:
- First_name cont�m um 'r' ap�s as duas primeiras letras.
- Identifica o sexo como 'F'
- Nasceu em fevereiro, maio ou dezembro
- Seu peso seria entre 60kg e 80kg
- O ID do paciente � um n�mero �mpar
- Eles s�o da cidade 'Kingston'*/

select 
	*
from patients
where 
	first_name like '__r%' 
	and city = 'Kingston'
	and gender = 'F' 
	and (month(birth_date) = 2 OR month(birth_date) = 5 OR month(birth_date) = 12)
	and weight between 60 and 80
    
/*SOLUCAO ALTERNATIVA*/
SELECT *
FROM patients
WHERE
  first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';
and patient_id % 2 = 1


/*Mostre a porcentagem de pacientes que t�m 'M' como g�nero. Arredonde a 
resposta para o cent�simo mais pr�ximo e na forma de porcentagem.*/
SELECT 
CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      4
    ) * 100,
    '%'
  ) as Percent_Pacientes_Masculinos
FROM patients;


/*Para cada dia, exiba a quantidade total de admiss�es naquele dia. Exibe o valor 
alterado desde a data anterior.*/

select admission_date,
count(*) 
	as admissao_dia,
count(admission_date) - lag(count(admission_date)) over (order by admission_date)
	as admissao_dia_anterior
from admissions
group by admission_date
/*LAG Use essa fun��o anal�tica em uma instru��o SELECT para comparar valores 
na linha atual com valores em uma linha anterior.*/


/*Classifique os nomes das prov�ncias em ordem crescente de forma que a 
prov�ncia 'Ontario' esteja sempre no topo.*/

select province_name
from province_names 
order by 
	(case when province_name = 'Ontario' then 0 else 1 end), 
    province_name


