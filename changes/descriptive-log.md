> # Descriptive log of changes to the qm ViCo questionnaire

# Questions added for TAC adult pneumonia etiology study
## `272770f818311c3a523eaae62b70ab97acda61d4`
### jmccracken
#### 2015-06-06

Questions added for TAC adult pneumonia etiology study:

- H2 Revision 1, 2 and 2.1
- H5 Muestras 2.6.2
- H3 D 3, 3.1, 3.2, 3.3, 3.4, 3.4.1, 3.4.1.1
- H3 A 2.9, 2.10


---


# Improve log management
## `aef9530a002a061cd6a4b980785e225f46617e8b`
### odeleongt [nb]
#### 2015-06-11 14:55:46 -0600
Improve log management



---


# Remove insect questions
## `1f9ddd26af9b480feffdf6d4a183618db22c31a3`
### blopez
#### 2015-06-16 09:21:17 -0600


Changes to questionarie Beatriz L?pez  Date June 16 2015

The following question were deleted because we had never found any insects in patients during the 8 years of the study

3.4 ¿Consiguió garrapatas, piojos o pulgas del paciente?
3.5 Si colectó muestra de insectos
3.5.1 ¿Qué tipo de insectos colectó?
3.5.2 ¿Cuántos insectos colectó?



---


# WASH QUESTIONS
## `1f9ddd26af9b480feffdf6d4a183618db22c31a3`
### blopez
#### 2015-06-17 06:28:49 -0600
Changes to Questionarrie BLopez June 17 2015 I added 5 questions about WASH lines 605 to 60 SPELLING Blopes June 17 2015 Initial Spelling revisiton of all questions




---


# Add response options to wash questions
## `d4764619bae99ddde35427894a3b85ac06b8b538`
### blopez
#### 2015-06-17 08:30:26 -0600
Add response options to wash questions
There was no stablished way to record response options, I added those to the comments column.




---


# Move blood culture questions from H5 to H7
## `40a0be000492c3c512f1abaa715fe19882dff8e4`
### odeleongt [nb]
#### 2015-06-19 10:42:45 -0600
Move blood culture questions from H5 to H7


These questions were often skipped since they where asked when the blood culture assay had not been performed or the results were not yet available. We moved them to H7 to ask them when the patient discharge information is recorded.



---

# QUESTIONS FOR PERTUSSIS SURVEILLANCE
## `cf7e69dfd35539ec234ee8b8ba621276ffc78a80`
### hmaldonado
#### 2015-06-19 13:52:53 -0600
QUESTIONS FOR PERTUSSIS SURVEILLANCE

4 questions were added to record H2 revisi?n de expediente clinico
The drafting of 3 questions related to whooping cough was modified
H2 inscripción de diarrea y respiratoria

Elegibility Methods are pending

---

# Merge branch 'changes/odeleon' into develop
## `0a3742702aac3d5808dd3d540f30ae5c15d4889f`
### odeleongt [nb]
#### 2015-06-24 09:07:26 -0600
Merge branch 'changes/odeleon' into develop


---

# Order and update stool sample questions
## `73da759da7e486fdc12a2c85f01516a7fa6b0c74`
### cjarquin
#### 2015-06-26 19:52:30 -0600
Order and update stool sample questions
Changed the order of questions pertaining to stool sample collection, added specification of sample type collected in H3-Muestra


---

# Removed questions on zinc
## `e65cb77e3f5c25f5245bf2e043eac9f1e432878e`
### cjarquin
#### 2015-06-26 19:52:30 -0600
Removed questions on zinc
Removed questions on zinc, B-Treatment


---

# Add and update TRAction questions
## `a0c6c50501552363efbae86521495b293aa245cb`
### cjarquin
#### 2015-06-26 19:52:31 -0600
Add and update TRAction questions
Added questions from TRAction analysis on WASH, modified some of the questions Beatriz added.


---

# Modifications to H3 Immunization and chronic disease
## `94f947e2de5a1dcc6dba74905ddb13995b8b0eaa`
### hmaldonado
#### 2015-06-30 19:17:43 -0600
Modifications to H3 Immunization and chronic disease

1. Modifications according to IRB review
2. Add questions of vaccines:  BCG, Oral polio vaccine
3. Delete question of Difteria, Pertussis and Tetanus Vaccine, this vaccine is  no more available in Guatemala for children under 5 years, only for booster
4. Add questions of rotavirus vaccine type:  rotarix, rotate
5. Add question of breastfeeding and steroid use
6. Delete question about HIV/other immunodeficiency (other questions were added from TAC questions for HIV and other immunodeficiency status)


---

# Fix change definitions
## `79f0d6a2b424f9d667a699054b87f15621e853c3`
### odeleongt
#### 2015-07-02 07:31:28 -0600
Fixes to change definitions

---

# Remove follow up questions (HCP9 Seguimiento)
## `19a2d527b59b2545b5db031ef4a08feab16ce530`
### odeleongt
#### 2015-07-02 09:32:04 -0600
Remove follow up questions (HCP9 Seguimiento)
This questionnaire section was inactive by design.

---

# Remove questions for neurological syndromes
## `d1eca38bc69c589b49727f9c44eba337a6db51d0`
### odeleongt
#### 2015-07-03 09:15:15 -0600
Remove questions for neurological syndromes
Questions removed from the sections:

- H1 Sospechosos
- Revisión del expediente médico
- H2 Inscripción
- H7 Egreso

and related variables


---

# Update febrile syndrome questions
## `6bba9fd726c46921e5103c2eae692016d224d7d1`
### odeleongt [nb]
#### 2015-10-08 17:26:26 -0600
Update febrile syndrome questions

- We changed the text 'irritación de la piel' to '"rash" o "sarpullido"' to improve accuracy of the medical presentation we are interested in
- The question about having "rash" or "sarpullido" will be now stored as the new variable "hxF_Rash" (stored as "hxF_IrritacionPiel" before rewording)
- Improve question wording in questionnaire "H3 Informe del Caso" section "K - Hx Febril"  
- Remove questions in questionnaire "H3 Informe del Caso" section "K - Hx Febril" related to neck stiffness, facio-muscular weakness and photographs of skin irritation  
- We added questions about hepatomegaly and splenomegaly on section "H2 Comun". These are clinical signs of some causes of acute febrile illness

