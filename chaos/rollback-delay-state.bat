kubectl delete -f deploy-toxic.yaml

pushd "./../cluster" 

call .\drop_stage.bat 

popd

pushd "./../cluster" 

call .\stage.bat

popd
