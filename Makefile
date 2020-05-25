.PHONY: inject-token

inject-token:
	echo "const String qiitaAccessToken = '${TOKEN}';" > ./lib/secret.dart