# 
# Generates API documentation with the help of appledoc.
# Generates both HTML code and a DocSet (which *can* be installed into Xcode).
#
# Copyright (c) 2011 Fruit is Good. All rights reserved.
#

API_DOCS_DIR=`pwd`"/${1}"
DOC_GUIDES_DIR=`pwd`"/${1}/Guides"

echo "API documentation generation script (v2)"
echo "Will save generated documentation into \"${API_DOCS_DIR}\""
echo "Removing old API documentation"
rm -r $API_DOCS_DIR/html 2> /dev/null
rm -r $API_DOCS_DIR/docset 2> /dev/null

HEADER_DIRECTORIES="${2}"
echo "Finding header files in:"
echo ${HEADER_DIRECTORIES}
HEADER_FILES=`find ${HEADER_DIRECTORIES} -name '*.h' | grep -v Private`
echo "Will generate API documentation based on:"
echo ${HEADER_FILES}

echo "Generating API documentation into \"${API_DOCS_DIR}\" for version \"${DOCS_LIBRARY_VERSION}\""
/usr/local/bin/appledoc \
--verbose 3 \
--output "${API_DOCS_DIR}" \
--keep-intermediate-files \
--no-install-docset \
--project-version "${DOCS_LIBRARY_VERSION}" \
--project-name "ObjectiveHub" \
--project-company "Fruit is Good" \
--company-id "com.fruitisgood" \
--index-desc "${API_DOCS_DIR}/Index.markdown" \
${HEADER_FILES}

echo "Done!"
