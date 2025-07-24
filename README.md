# Repository description
This OSF repository contains data and code for the manuscript, ‘The rise, impact, and inequity of big team psychology’.

## Note on computational workflow
To begin, we recommend reviewing btpsych24a_FileOrganization.png, which illustrates the project’s computational workflow. This includes the initial pulling of articles (btpsych24a_api.Rmd) to making key figures (btpsych24a_impact.Rmd) to compiling key results (btpsych24a_paper.refs.Rmd).

The project’s workflow is computationally intensive. For researchers who need a computationally efficient method for evaluating our workflow (e.g., checking reproducibility), we have provided “smaller” versions of central datasets that contain a randomly selected proportion (usually 5%) of data. Adjusting code to load these dataframes can save hours of time – and is sometimes necessary for those with less computational resources (e.g., older computers).
Session info for the main computing device used to develop and run the code is available in btpsych24a_SessionInfo.txt.

## Note on proprietary nature of Altmetric data
The Altmetric data used in this paper is proprietary. We only have permission to share for private peer review. 
https://help.altmetric.com/support/solutions/articles/6000254871-faqs-for-scientometric-researchers

Data were made available during the initial peer review process, and we are firmly committed to sharing with others who wish to engage in post-publication review. In fact, we believe that *not* doing so would violate data retention rules at our host institution (see DataRetentionGuidelines_012625.pdf).

To facilitate data sharing for legitimate private peer review cases, we have uploaded encrypted copies of Altmetric data to this OSF repository. Please contact the corresponding author for the password.

To further support efforts to assess the computational reproducibility of our workflow, we have uploaded scrambled copies of Altmetric data to this OSF repository. These scrambled data do not require a password to use.

# Description of major files

## Main directory
•	btpsych24a_api.Rmd: This code downloads all psychology papers published between 2000 and 2023 from OpenAlex using their API package. It then merges these files and exports as a .RDS file.
•	btpsych24a_cont_reliability_prep.Rmd: This code creates a spreadsheet for checking the reliability of contributorship coding.
•	btpsych24a_cont_reliability.Rmd: This code examines the reliability of contributorship coding by JT and GG.
•	btpsych24a_contributorship.Rmd: This code creates the contributorship figure
•	btpsych24a_filter.Rmd: This code processes OpenAlex data and prepares other essential data files.
•	btpsych24a_impact.Rmd: This code prepares a figure that illustrates links between team size and multiple measures of impact.
•	btpsych24a_map.Rmd: This code creates a figure that (a) illustrates the geographical distribution of big team leadership and participation rates in psychology, and (b) examines links between those rates and indicators of economic wealth (GDP).
•	btpsych24a_paper.refs.Rmd: This code compiles the numbers quoted in the paper.
•	btpsych24a_SessionInfo.txt: Session info for the main computing device used to develop and run the code.
•	btpsych24a_timetopic.Rmd: This code creates a figure illustrating (a) frequency of big team psychology efforts over time, and (b) the topics they study.

### admin folder
•	btpsych24a_FileOrganization.png: This figure illustrates the project’s computational workflow, highlighting the main scripts and data sets that were used in our analysis. 
•	DataRetentionGuidelines_012625.pdf: Copy of Data Retention Guidelines at the corresponding authors’ institution.
•	PsycInfo_AcceptableUse.pdf: Confirmation of permissible re-use of PsycInfo topic labels.

### data folder
•	btpsych24a_codebook.xlsx: This spreadsheet is a codebook with variable descriptions for each of the spreadsheets within the data folder.  

#### altmetric subfolder
•	btpsych24a_altmetric1_scramble.csv: This spreadsheet contains the DOI, scholarly citation, news mention, policy mention and social media mention data extracted from Altmetric of the first subset of papers extracted from OpenAlex, scrambled for reproducibility.
•	btpsych24a_altmetric2_scramble.csv: This spreadsheet contains the DOI, scholarly citation, news mention, policy mention and social media mention data extracted from Altmetric of the second subset of papers extracted from OpenAlex, scrambled for reproducibility.
•	btpsych24a_bib_doi1_raw.csv: This spreadsheet contains the OpenAlex ID and DOI of the first subset of papers extracted from OpenAlex, which was used for Altmetric data extraction.
•	btpsych24a_bib_doi2_raw.csv: This spreadsheet contains the OpenAlex ID and DOI of the second subset of papers extracted from OpenAlex, which was used for Altmetric data extraction.
•	btpsych24a_password.protected.altmetric.zip: Encrypted copy of proprietary Altmetric data. Made available for private peer review.

#### contributorship subfolder
•	btpsych24a_cont_coding_instructions.docx: This document contains the instructions coders received when coding the author contributions.
•	btpsych24a_cont_coding_rel.csv: this spreadsheet contains a subset of btpsych24a_cont_coding that was recoded by the authors and used for a reliability analysis. 
•	btpsych24a_cont_coding.csv: this spreadsheet contains a set of 1000 psychology papers, their identifying information extracted from OpenAlex, their extracted contribution statements, and the categories of their authors’ contributions coded by the researchers.
•	btpsych24a_cont_processed.Rds: This R object contains the processed contributorship data coded by the researchers and recorded in btpsych24a_cont_coding.csv.

#### location subfolder
•	btpsych24a_geocode.Rds: This R object contains geographical data from the authors of big team psychology paper and their affiliated institutions.

#### openalex subfolder
•	btpsych24a_author.n.correction.csv: When articles have over 100 authors, OpenAlex’s API only pulls meta-data for the first 100 authors. This .csv file contains manually extracted estimates of authorship counts for those records. 
•	btpsych24a_data_bib_processed.Rds: This R object contains the processed data of all psychology papers extracted from OpenAlex.
•	btpsych24a_data_bib_processed_SMALLER.Rds:  This R object contains a 5% sample of btpsych24a_data_bib_processed.Rds, for less computationally intensive reproduction of results.
•	btpsych24a_data_bib_raw.Rds: This R object contains the raw data of all the psychology papers extracted from OpenAlex.
•	btpsych24a_data_bib_raw_SMALLER.Rds: This R object contains a 5% sample of btpsych24a_data_bib_raw.Rds, for less computationally intensive reproduction of results.

#### topic subfolder
•	btpsych24a_APAPsycInfo ClassificationCodes.pdf: This document describes the classification system used by APA’s PsycINFO database.
•	btpsych24a_topic.csv: This spreadsheet contains a set of 2193 psychology papers randomly extracted from the OpenAlex dataset and their PsycINFO classification. 
•	btpsych24a_topiccoding.csv: This spreadsheet contains a set of 2193 psychology papers randomly extracted from the OpenAlex dataset and stratified by team size, which was used to create btpsych24a_topic.csv.

#### worlddata subfolder
•	btpsych24a_f.author_gdp.csv: This spreadsheet contains data about GDP, GDP per capita, and the number of first authors of big team psychology papers by country. 
•	btpsych24a_s.author_gdp.csv: This spreadsheet contains data about GDP, GDP per capita, and the number of non-first authors of big team psychology papers by country.
•	btpsych24a_worlddata_gdp.csv: This spreadsheet contains GDP data for most countries and was obtained from the WorldBank GDP data.
•	btpsych24a_worlddata_gdp_pc.csv: This spreadsheet contains data of GDP per capita for most countries and was obtained from the WorldBank GDP data.
•	btpsych24a_worlddata_gdp.pc_codebook1.csv: This spreadsheet is the first codebook for the btpsych24a_worlddata_gdp_pc.csv file. Exported from WorldBank.
•	btpsych24a_worlddata_gdp.pc_codebook2.csv: This spreadsheet is the second codebook for the btpsych24a_worlddata_gdp_pc.csv file. Exported from WorldBank.
•	btpsych24a_worlddata_gdp_codebook1.csv: This spreadsheet is the first codebook for the btpsych24a_worlddata_gdp.csv file. Exported from WorldBank.
•	btpsych24a_worlddata_gdp_codebook2.csv: This spreadsheet is the second codebook for the btpsych24a_worlddata_gdp.csv file. Exported from WorldBank.

### writing folder
•	btpsych_manuscript.docx: This document contains the pre-submission version of the manuscript 
•	btpsych_supplement.docx: This document contains supplementary data about the contributorship patterns in big team psychology papers, alternative statistical operationalizations of impact, and inclusion/exclusion of extremely big teams in the analysis.