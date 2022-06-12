conda create -y -n alphafold python=3.7 numpy scipy ipykernel cudatoolkit tqdm openmm=7.5.1 pdbfixer
conda activate alphafold
conda install -y -c bioconda hmmer 
pip install py3dmol
wget -P /home/studio-lab-user/alphafold/content https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

GIT_REPO='https://github.com/deepmind/alphafold'
SOURCE_URL='https://storage.googleapis.com/alphafold/'
SOURCE_TAR='alphafold_params_colab_2021-10-27.tar'
PARAMS_DIR='/home/studio-lab-user/alphafold/data/params'
PARAMS_PATH=${PARAMS_DIR}/${SOURCE_TAR}

pushd /home/studio-lab-user/alphafold
git clone --branch main ${GIT_REPO} alphafold
pip3 install -r ./alphafold/requirements.txt
pip3 install --no-dependencies ./alphafold
popd
pushd /home/studio-lab-user/.conda/envs/alphafold/lib/python3.7/site-packages
patch -p0 < /home/studio-lab-user/alphafold/alphafold/docker/openmm.patch
popd
mkdir -p /home/studio-lab-user/alphafold/alphafold/alphafold/common
cp -f /home/studio-lab-user/alphafold/content/stereo_chemical_props.txt /home/studio-lab-user/alphafold/alphafold/alphafold/common

mkdir -p /home/studio-lab-user/.conda/envs/alphafold/lib/python3.7/site-packages/alphafold/common/
cp -f /home/studio-lab-user/alphafold/content/stereo_chemical_props.txt /home/studio-lab-user/.conda/envs/alphafold/lib/python3.7/site-packages/alphafold/common/

mkdir -p ${PARAMS_DIR}
wget -O ${PARAMS_PATH} ${SOURCE_URL}${SOURCE_TAR}

tar --extract --verbose --file=${PARAMS_PATH} --directory=${PARAMS_DIR} --preserve-permissions
rm ${PARAMS_PATH}