library(tidyr)
library(dplyr)
library(xml2)

# read in xml dta for wsdot stations metadata
meta_xml <- as_list(read_xml("https://wsdot.wa.gov/Traffic/WebServices/SWRegion/Service.asmx/GetRMDCLocationData"))
