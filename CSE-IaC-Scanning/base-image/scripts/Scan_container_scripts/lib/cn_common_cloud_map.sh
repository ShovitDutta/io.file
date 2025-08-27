



#for all in `cat regex_rules.json | jq -r -c '.rules[]|.name' | cut -d ":" -f 1`; do uuid=$(/apps/kics/bin/kics generate-id); echo "cn_common_cloud_map['${all}_azure']='${uuid}'"; done > cn_common_cloud_map.sh
#for all in `cat regex_rules.json | jq -r -c '.rules[]|.name' | cut -d ":" -f 1`; do uuid=$(/apps/kics/bin/kics generate-id); echo "cn_common_cloud_map['${all}_gcp']='${uuid}'"; done >> cn_common_cloud_map.sh
#for all in `cat regex_rules.json | jq -r -c '.rules[]|.name' | cut -d ":" -f 1`; do uuid=$(/apps/kics/bin/kics generate-id); echo "cn_common_cloud_map['${all}_aws']='${uuid}'"; done >> cn_common_cloud_map.sh

#COMMON PASSWORD_AND_SECRETS ORIGINAL IDS -Start
    declare -A pwd_sec

    pwd_sec["487f4be7-3fd9-4506-a07a-eae252180c08"]="487f4be7-3fd9-4506-a07a-eae252180c08|Generic_Password"
    pwd_sec["3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99"]="3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99|Generic_Secret"
    pwd_sec["51b5b840-cd0c-4556-98a7-fe5f4def80cf"]="51b5b840-cd0c-4556-98a7-fe5f4def80cf|Asymmetric_private_key"
    pwd_sec["a007a85e-a2a7-4a81-803a-7a2ca0c65abb"]="a007a85e-a2a7-4a81-803a-7a2ca0c65abb|Putty_User_Key_File_Content"
    pwd_sec["c4d3b58a-e6d4-450f-9340-04f1e702eaae"]="c4d3b58a-e6d4-450f-9340-04f1e702eaae|Password_in_URL"
    pwd_sec["76c0bcde-903d-456e-ac13-e58c34987852"]="76c0bcde-903d-456e-ac13-e58c34987852|AWS_Access_Key"
    pwd_sec["76c0bcde-903d-456e-ac13-e58c34987852"]="76c0bcde-903d-456e-ac13-e58c34987852|AWS_Context-specific_credential"
    pwd_sec["76c0bcde-903d-456e-ac13-e58c34987852"]="76c0bcde-903d-456e-ac13-e58c34987852|AWS_Certificate"
    pwd_sec["83ab47ff-381d-48cd-bac5-fb32222f54af"]="83ab47ff-381d-48cd-bac5-fb32222f54af|AWS_Secret_Key"
    pwd_sec["4b2b5fd3-364d-4093-bac2-17391b2a5297"]="4b2b5fd3-364d-4093-bac2-17391b2a5297|K8s_Environment_Variable_Password"
    pwd_sec["d651cca2-2156-4d17-8e76-423e68de5c8b"]="d651cca2-2156-4d17-8e76-423e68de5c8b|Google_OAuth"
    pwd_sec["ccde326f-ebc7-4772-8ad5-de66e90a8cc3"]="ccde326f-ebc7-4772-8ad5-de66e90a8cc3|Slack_Webhook"
    pwd_sec["d6214dca-a31b-425f-bcf7-f4faa772a1c0"]="d6214dca-a31b-425f-bcf7-f4faa772a1c0|MSTeams_Webhook"
    pwd_sec["7908a9e3-5cac-41b1-b514-5f6d82ce02d5"]="7908a9e3-5cac-41b1-b514-5f6d82ce02d5|Slack_Token"
    pwd_sec["6abcae17-b175-4698-a9a5-b07661974749"]="6abcae17-b175-4698-a9a5-b07661974749|Stripe_API_Key"
    pwd_sec["0b1b2482-51e7-49d1-893d-522afa4a6bd0"]="0b1b2482-51e7-49d1-893d-522afa4a6bd0|Square_Access_Token"
    pwd_sec["6c54f9da-1a11-445a-8568-0d327e6af8be"]="6c54f9da-1a11-445a-8568-0d327e6af8be|MailChimp_API_Key"
    pwd_sec["e9856348-4069-4ac0-bd91-415f6a7b84a4"]="e9856348-4069-4ac0-bd91-415f6a7b84a4|Google_API_Key"
    pwd_sec["9a3650af-5b88-48cd-ab89-cd77fd0b633f"]="9a3650af-5b88-48cd-ab89-cd77fd0b633f|Heroku_API_Key"
    pwd_sec["bb51eb1e-0357-44a2-86d7-dd5350cffd43"]="bb51eb1e-0357-44a2-86d7-dd5350cffd43|Square_OAuth_Secret"
    pwd_sec["ac8c8075-6ec0-4367-9e26-30ec8161d258"]="ac8c8075-6ec0-4367-9e26-30ec8161d258|Amazon_MWS_Auth_Token"
    pwd_sec["41a1ca8d-f466-4084-a8c9-50f8b22200d5"]="41a1ca8d-f466-4084-a8c9-50f8b22200d5|Google_OAuth_Access_Token"
    pwd_sec["4919b847-e3da-402a-acf8-6cea8e529993"]="4919b847-e3da-402a-acf8-6cea8e529993|PayPal_Braintree_Access_Token"
    pwd_sec["54274b18-bfac-47ce-afd1-0f05bc3e3b59"]="54274b18-bfac-47ce-afd1-0f05bc3e3b59|Stripe_Restricted_API_Key"
    pwd_sec["5176e805-0cda-44fa-ac96-c092c646180a"]="5176e805-0cda-44fa-ac96-c092c646180a|Facebook_Access_Token"
    pwd_sec["74736dd1-dd11-4139-beb6-41cd43a50317"]="74736dd1-dd11-4139-beb6-41cd43a50317|Generic_API_Key"
    pwd_sec["62d0025d-9575-4eff-b60b-d3b4fcec0d04"]="62d0025d-9575-4eff-b60b-d3b4fcec0d04|Mailgun_API_Key"
    pwd_sec["50cc5f03-e686-4183-97e9-12f9b55d0f97"]="50cc5f03-e686-4183-97e9-12f9b55d0f97|Picatic_API_Key"
    pwd_sec["e0f01838-b1c2-4669-b84b-981949ebe5ed"]="e0f01838-b1c2-4669-b84b-981949ebe5ed|Twilio_API_Key"
    pwd_sec["7f370dd5-eea3-4e5f-8354-3cb2506f9f13"]="7f370dd5-eea3-4e5f-8354-3cb2506f9f13|Generic_Access_Key"
    pwd_sec["2f665079-c383-4b33-896e-88268c1fa258"]="2f665079-c383-4b33-896e-88268c1fa258|Generic_Private_Key"
    pwd_sec["baee238e-1921-4801-9c3f-79ae1d7b2cbc"]="baee238e-1921-4801-9c3f-79ae1d7b2cbc|Generic_Token"
    pwd_sec["e0f01838-b1c2-4669-b84b-981949ebe5ed"]="e0f01838-b1c2-4669-b84b-981949ebe5ed|CloudFormation_Secret_Template"
    pwd_sec["9fb1cd65-7a07-4531-9bcf-47589d0f82d6"]="9fb1cd65-7a07-4531-9bcf-47589d0f82d6|Encryption_Key"
    pwd_sec["8a879bc7-6f82-40fd-bb48-74d25d557fe8"]="8a879bc7-6f82-40fd-bb48-74d25d557fe8|SendGrid_API_Key"
    pwd_sec["be0ed753-d304-4363-844a-144050d4006d"]="be0ed753-d304-4363-844a-144050d4006d|Generic_Password_on_YAML_files_when_value_in_tuple"

#COMMON PASSWORD_AND_SECRETS ORIGINAL IDS -Start

    declare -A cn_common_cloud_map

#azure_conversion_map -Start
            cn_common_cloud_map['CN-0001_azure']='339ceb82-1fe5-4c95-af17-045c952d1cc0'
            cn_common_cloud_map['CN-0002_azure']='6e3e723b-6434-49d6-8248-0912a0744cc5'
            cn_common_cloud_map['CN-0003_azure']='6638b421-069a-4ae4-8db3-8baa13bb1522'
            cn_common_cloud_map['CN-0004_azure']='8f5d8936-6219-4f57-8b74-2a8027d289e5'
            cn_common_cloud_map['CN-0005_azure']='0aeb9a39-240f-48b0-aeef-fc37739aaa34'
            cn_common_cloud_map['CN-0006_azure']='0db587e3-b781-4f15-a7dc-46e1aeaf37e9'
            cn_common_cloud_map['CN-0007_azure']='83c41e83-dc70-4d59-bb6e-786849a5a18e'
            cn_common_cloud_map['CN-0008_azure']='704ddde9-701c-407e-8a74-fd848bfefa70'
            cn_common_cloud_map['CN-0009_azure']='776551f0-994f-4417-8069-406ce3eee8cd'
            cn_common_cloud_map['CN-0010_azure']='3c160cbd-9ec1-458f-861a-c91b73adbbf5'
            cn_common_cloud_map['CN-0011_azure']='45e0eb71-ffc8-438b-8644-9ca4969c5f69'
            cn_common_cloud_map['CN-0012_azure']='4b411d0f-9e06-4b3a-b06e-84bd58ad2e31'
            cn_common_cloud_map['CN-0013_azure']='1edd2eaf-4358-4d2a-9f94-9f9c460c49cb'
            cn_common_cloud_map['CN-0014_azure']='0874f1be-2875-42b6-8bc5-6b900fc29fec'
            cn_common_cloud_map['CN-0015_azure']='492b7d4f-28f9-4b09-ad93-b0c5b7550a0b'
            cn_common_cloud_map['CN-0016_azure']='13617092-b5cf-4b78-96fe-490acfe2fb6a'
            cn_common_cloud_map['CN-0017_azure']='7acf0733-28c0-467b-ac0b-505adde69811'
            cn_common_cloud_map['CN-0018_azure']='56ab65d5-f3ac-4476-9e83-1455045f4528'
            cn_common_cloud_map['CN-0019_azure']='22a276c0-3a9c-47da-a7c2-c4cf7f53f1ff'
            cn_common_cloud_map['CN-0020_azure']='2ba3d039-4a48-4d2b-9313-9dd0e4ab33a3'
            cn_common_cloud_map['CN-0021_azure']='d3e42f01-fde9-4d7e-acf4-6193aff2110e'
            cn_common_cloud_map['CN-0022_azure']='13084557-af51-4319-b852-63da968c268a'
            cn_common_cloud_map['CN-0023_azure']='0fc1d4ef-d3bd-4ae4-94f5-b4212d746403'
            cn_common_cloud_map['CN-0024_azure']='f65012b6-d3b5-4c47-94f6-274d4eb9258a'
            cn_common_cloud_map['CN-0025_azure']='c0f02e0c-7b93-425b-8f05-2745e5afd1d7'
            cn_common_cloud_map['CN-0026_azure']='497de06e-3934-49ff-a1d8-259831692992'
            cn_common_cloud_map['CN-0027_azure']='04a06f16-ba07-4a63-b377-1c1208128729'
            cn_common_cloud_map['CN-0028_azure']='4e7e6f69-eb61-4130-a414-3fd8d3ea0cf1'
            cn_common_cloud_map['CN-0029_azure']='46a7eee6-7c30-4fac-b59e-9fec8415cb9d'
            cn_common_cloud_map['CN-0030_azure']='4e927302-eb3d-44d5-a1ce-8efc2bee93fd'
            cn_common_cloud_map['CN-0031_azure']='ca09f538-f6e6-48ba-8bfe-96fd6db08124'
            cn_common_cloud_map['CN-0032_azure']='b2a541d4-4ef1-4675-a821-20c8cb308145'
            cn_common_cloud_map['CN-0033_azure']='3e80f040-0086-4f4e-9d0b-96de9a74463c'
            cn_common_cloud_map['CN-0034_azure']='aadf0f6c-8f6b-446a-b5ce-7775c701cb3f'
            cn_common_cloud_map['CN-0035_azure']='6c26b8ff-4b97-4bb8-bb99-e7244a47b003'
            cn_common_cloud_map['CN-0036_azure']='7714d117-2dca-4b4d-a85c-8559d07cf0c6'

#azure_conversion_map -End

#gcp_conversion_map -Start
            cn_common_cloud_map['CN-0001_gcp']='ad368bd7-5d12-4a58-833a-9dce665da82a'
            cn_common_cloud_map['CN-0002_gcp']='0e4dc9f4-18b0-4bd7-b495-354f4ed57786'
            cn_common_cloud_map['CN-0003_gcp']='ddcd277a-1009-4317-8dfe-cf11a4fc1a4a'
            cn_common_cloud_map['CN-0004_gcp']='ca8bff97-d429-4788-b888-96b0f287d3a9'
            cn_common_cloud_map['CN-0005_gcp']='43b383d9-ac6b-4b49-b461-8d5b66ee8a79'
            cn_common_cloud_map['CN-0006_gcp']='2d8882fc-4a7e-4d51-ace2-8f122716c2f4'
            cn_common_cloud_map['CN-0007_gcp']='7f5a5b71-1770-4423-857f-41630f3b131b'
            cn_common_cloud_map['CN-0008_gcp']='4982618c-35e8-43e2-88b6-89ee577fa707'
            cn_common_cloud_map['CN-0009_gcp']='07f55e64-146a-488b-8947-c8e1b1ce7a84'
            cn_common_cloud_map['CN-0010_gcp']='1acd017e-23a9-42a8-9094-a2735491e5b7'
            cn_common_cloud_map['CN-0011_gcp']='fb73c0b0-1a27-476e-b03f-5f129f2c9c27'
            cn_common_cloud_map['CN-0012_gcp']='12693317-8336-463c-9a14-1957d76d5a69'
            cn_common_cloud_map['CN-0013_gcp']='c640c74f-6b90-43b6-819c-713b7501e285'
            cn_common_cloud_map['CN-0014_gcp']='22b83897-8329-4feb-932f-9bf37595e490'
            cn_common_cloud_map['CN-0015_gcp']='0385df2c-6e15-48e4-b0b7-d5c833594819'
            cn_common_cloud_map['CN-0016_gcp']='c46b814e-2ad2-481c-8d46-8806234ce2eb'
            cn_common_cloud_map['CN-0017_gcp']='d1e19d51-ec63-4f74-a5fc-1743aecf4282'
            cn_common_cloud_map['CN-0018_gcp']='ddac3d13-6c90-40a8-bebc-5f940408994f'
            cn_common_cloud_map['CN-0019_gcp']='dc77fad7-e5a1-45b0-a9dd-a415eafc4b04'
            cn_common_cloud_map['CN-0020_gcp']='61cc0b2d-ace5-4f02-871c-fb57c80c0830'
            cn_common_cloud_map['CN-0021_gcp']='0a47a10b-2b3f-49cd-a65c-83481dcc8ff1'
            cn_common_cloud_map['CN-0022_gcp']='492fe07f-3a5d-4f2c-ac2b-74eb0c41b283'
            cn_common_cloud_map['CN-0023_gcp']='321b316c-0076-4473-a690-a643b668bb8e'
            cn_common_cloud_map['CN-0024_gcp']='debdc84f-5478-4acc-b271-02eb884c75cd'
            cn_common_cloud_map['CN-0025_gcp']='4f55eef3-9606-4431-8144-c61ce6f68b1e'
            cn_common_cloud_map['CN-0026_gcp']='e86319c2-c753-4bf0-ae4d-962c98d7a1a9'
            cn_common_cloud_map['CN-0027_gcp']='8e336940-64a8-46ad-bf9f-871b24672a91'
            cn_common_cloud_map['CN-0028_gcp']='7bc5d53b-6f0a-4750-bd65-8061e9f77d81'
            cn_common_cloud_map['CN-0029_gcp']='af19f0a9-ce47-44ef-84b6-5192710ecbd1'
            cn_common_cloud_map['CN-0030_gcp']='b9a55924-ada5-4ca3-9732-dafb3487f8e3'
            cn_common_cloud_map['CN-0031_gcp']='0bb21998-579f-4e1f-8214-086440846e02'
            cn_common_cloud_map['CN-0032_gcp']='1ba147dc-6755-418f-a1b5-97df9d0aa604'
            cn_common_cloud_map['CN-0033_gcp']='ce8ca915-4a8f-418b-9fa4-476e2a737b3b'
            cn_common_cloud_map['CN-0034_gcp']='449a3d84-bf17-4274-a4c8-93eb59babb05'
            cn_common_cloud_map['CN-0035_gcp']='7301011f-83f7-444e-ae21-c1fc205c183e'
            cn_common_cloud_map['CN-0036_gcp']='5af43a9f-4450-4db9-84a0-29b3e4e24d5f'
#gcp_conversion_map -End

#aws_conversion_map -Start
            cn_common_cloud_map['CN-0001_aws']='6e8e3292-87df-44a8-9ea1-e3b26674a422'
            cn_common_cloud_map['CN-0002_aws']='ea5f97ef-d329-4f41-9e1c-2defb0ac5e51'
            cn_common_cloud_map['CN-0003_aws']='e7a98864-9e22-45e3-8fba-4cdef7fb6802'
            cn_common_cloud_map['CN-0004_aws']='dfa74d80-223f-4e2b-8814-d53937cc8edc'
            cn_common_cloud_map['CN-0005_aws']='4ba5bdb5-dd85-4f85-b594-ce4906d0d5b8'
            cn_common_cloud_map['CN-0006_aws']='3131cc97-e994-4525-bcfb-30f0f3526530'
            cn_common_cloud_map['CN-0007_aws']='fdd6322f-b6ac-4bd7-8376-7539d4d8ae24'
            cn_common_cloud_map['CN-0008_aws']='98834b6b-0bfa-445a-b2c6-6fc9cba99b35'
            cn_common_cloud_map['CN-0009_aws']='25dab4c1-8364-41a9-81bc-61ac84cc4071'
            cn_common_cloud_map['CN-0010_aws']='3342743f-8e40-41cb-8822-d13ebbdb135b'
            cn_common_cloud_map['CN-0011_aws']='974ef36e-ad3f-4fbe-ae6b-576cf6036e6f'
            cn_common_cloud_map['CN-0012_aws']='09ffd784-e9bb-4ec8-b402-721570676ecf'
            cn_common_cloud_map['CN-0013_aws']='84af7df2-1b7f-4254-8051-7f7d693b3897'
            cn_common_cloud_map['CN-0014_aws']='1c19804f-998f-4bd0-bab0-22a3d6f3ade7'
            cn_common_cloud_map['CN-0015_aws']='1839957f-ea56-4033-b7ff-85c614e2acd6'
            cn_common_cloud_map['CN-0016_aws']='020831d4-4596-4c38-b6a6-4d3e26458ab2'
            cn_common_cloud_map['CN-0017_aws']='d140748a-055c-45a2-986b-01c25889e1a9'
            cn_common_cloud_map['CN-0018_aws']='e443779b-81a5-457c-8617-a25d19adeae0'
            cn_common_cloud_map['CN-0019_aws']='f9a7d6db-427f-49c5-8c20-036fff86b828'
            cn_common_cloud_map['CN-0020_aws']='4d923957-7551-4df6-af97-94029862c296'
            cn_common_cloud_map['CN-0021_aws']='1625f635-85af-47c1-a2c4-38891a9ffba8'
            cn_common_cloud_map['CN-0022_aws']='9478a8ff-0f91-42ae-a9a2-5c4f166e5e90'
            cn_common_cloud_map['CN-0023_aws']='fb8a3bc4-cdaf-402a-ae90-a00834ed1100'
            cn_common_cloud_map['CN-0024_aws']='e0bd9007-5549-4654-ab79-8f337b7c7db3'
            cn_common_cloud_map['CN-0025_aws']='de51be2d-a163-4c87-9f88-249bc4f8ed7d'
            cn_common_cloud_map['CN-0026_aws']='26e3a6cb-1001-411d-a8b6-53d99c9dfacb'
            cn_common_cloud_map['CN-0027_aws']='702ae545-c615-4166-a234-04709c7f4977'
            cn_common_cloud_map['CN-0028_aws']='f1755674-66fe-45d0-83ea-a24860f6e065'
            cn_common_cloud_map['CN-0029_aws']='8e2174bf-7440-44ea-8564-1eddbc1e6ae4'
            cn_common_cloud_map['CN-0030_aws']='7ca26573-e05a-4eb8-9a42-967f93ec0de1'
            cn_common_cloud_map['CN-0031_aws']='c0c6d0d7-5663-48dc-b399-4e00b9970594'
            cn_common_cloud_map['CN-0032_aws']='d8a44672-abd2-4125-b5dc-0e487a98f70e'
            cn_common_cloud_map['CN-0033_aws']='3e8cc083-209c-4f7c-8e76-60fadbdc9665'
            cn_common_cloud_map['CN-0034_aws']='3524945c-0024-45f7-9e6d-c07c5c6a3f76'
            cn_common_cloud_map['CN-0035_aws']='560627f7-7968-40aa-96be-ecbe5adfad98'
            cn_common_cloud_map['CN-0036_aws']='c5cebfe3-661b-4330-828e-24484341a61f'
#aws_conversion_map -end
