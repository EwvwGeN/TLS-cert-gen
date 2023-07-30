export MSYS_NO_PATHCONV=1

# Path to file with variables
source "./cert/data"
CA_SUBJ="/C=$CA_COUNTRY/ST=$CA_STATE/L=$CA_SITY/O=$CA_ORGANIZATION/OU=$CA_UNIT/CN=$CA_NAME/emailAddress=$CA_EMAIL"
WS_SUBJ="/C=$WS_COUNTRY/ST=$WS_STATE/L=$WS_SITY/O=$WS_ORGANIZATION/OU=$WS_UNIT/CN=$WS_NAME/emailAddress=$WS_EMAIL"
echo $(dirname "$0")
rm $(dirname "$0")/*.pem
# CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -keyout $(dirname "$0")/ca-key.pem -out $(dirname "$0")/ca-cert.pem -subj "$CA_SUBJ"

echo "CA's self-signed certificate"
openssl x509 -in $(dirname "$0")/ca-cert.pem -noout -text

# Web server's private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -keyout $(dirname "$0")/server-key.pem -out $(dirname "$0")/server-req.pem -subj "$WS_SUBJ"

# CA's private key to sign web server's CSR and get back the signed certificate
openssl x509 -req -in $(dirname "$0")/server-req.pem -days 60 -CA $(dirname "$0")/ca-cert.pem -CAkey $(dirname "$0")/ca-key.pem -CAcreateserial -out $(dirname "$0")/server-cert.pem

echo "Server's signed certificate"
openssl x509 -in $(dirname "$0")/server-cert.pem -noout -text