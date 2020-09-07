rm -R -f cluster 
mkdir cluster 


pushd cluster 
git clone --branch develop git@github.com:owlvey/owlvey_falcon.git
rm -R -f "owlvey_falcon/.git"
git clone --branch develop git@github.com:owlvey/owlvey_identity.git
rm -R -f "owlvey_identity/.git"
git clone --branch develop git@github.com:owlvey/owlvey_falcon_ui.git
rm -R -f "owlvey_falcon_ui/.git"

popd

python3 ./local-builder.py

