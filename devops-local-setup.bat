rmdir /Q /S cluster 
mkdir cluster 


pushd cluster 
git clone --branch develop git@github.com:owlvey/owlvey_falcon.git
rmdir /Q /S "owlvey_falcon/.git"
git clone --branch develop git@github.com:owlvey/owlvey_identity.git
rmdir /Q /S "owlvey_identity/.git"
git clone --branch develop git@github.com:owlvey/owlvey_falcon_ui.git
rmdir /Q /S "owlvey_falcon_ui/.git"

popd

python ./local-builder.py

pushd cluster 

rem  build.bat

popd

pushd cluster 

REM cluster.bat

popd

