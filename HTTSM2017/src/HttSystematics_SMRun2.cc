#include "CombineHarvester/HTTSM2017/interface/HttSystematics_SMRun2.h"
#include <vector>
#include <string>
#include "CombineHarvester/CombineTools/interface/Systematics.h"
#include "CombineHarvester/CombineTools/interface/Process.h"
#include "CombineHarvester/CombineTools/interface/Utilities.h"

using namespace std;

namespace ch {
    
  using ch::syst::SystMap;
  using ch::syst::SystMapAsymm;
  using ch::syst::era;
  using ch::syst::channel;
  using ch::syst::bin_id;
  using ch::syst::process;
  using ch::syst::bin;
  using ch::JoinStr;
  
  void AddSMRun2Systematics(CombineHarvester & cb, int control_region, bool mm_fit, bool ttbar_fit) {
    std::vector<std::string> sig_procs = {"ggH","VBF","WH","ZH"}; 
    std::vector<std::string> all_mc_bkgs = {"ZL","ZJ","TTJ","W","VVJ","EWKZ"};
    
    // lumi
    cb.cp().process({"W"}).channel({"tt","em","mm","ttbar"}).AddSyst(cb,"lumi_13TeV_2016", "lnN", SystMap<>::init(1.025));
    if(mm_fit)       cb.SetFlag("filters-use-regex", true);
    
  }
}
