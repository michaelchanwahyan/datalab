# Clone Core Libraries
if ls /app/lib/dsutil; 
    then echo "Installed"; 
    else git clone https://github.com/IcarusSO/dsutil.git /app/lib/dsutil; 
fi

if ls /app/lib/nbparameterise; 
    then echo "Installed"; 
    else git clone https://github.com/IcarusSO/nbparameterise.git /app/lib/nbparameterise; 
fi

# PIP3 install
pip3 install -e /app/lib/dsutil ;
pip3 install -e /app/lib/nbparameterise;
