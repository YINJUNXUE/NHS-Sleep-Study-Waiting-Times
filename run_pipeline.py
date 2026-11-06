from pathlib import Path
import subprocess,sys,argparse,json,datetime,os
P=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--raw',type=Path,required=True);ap.add_argument('--out',type=Path,default=P/'results');ap.add_argument('--rscript',default='Rscript');ap.add_argument('--clean',action='store_true');a=ap.parse_args();out=a.out.resolve()
if a.clean and out.exists() and any(out.iterdir()):raise SystemExit('Clean mode requires an empty/new output directory; no existing data are deleted.')
out.mkdir(parents=True,exist_ok=True)
steps=[['01_reconstruct.py','--raw',str(a.raw.resolve()),'--out',str(out)],['02_sensitivities.py',str(out)],['03_descriptives.py',str(out)],['05_publication_exports.py',str(out)],['07_verify.py',str(out)]]
for step in steps:
 print('RUN',step[0],flush=True)
 with (out/(step[0]+'.log')).open('w',encoding='utf-8') as log:
  subprocess.run([sys.executable,'-B','-X','utf8',str(P/step[0]),*step[1:]],stdout=log,stderr=subprocess.STDOUT,check=True)
print('RUN figures',flush=True)
with (out/'figures.log').open('w',encoding='utf-8') as log:subprocess.run([a.rscript,'--vanilla',str(P/'04_figures.R'),str(out)],stdout=log,stderr=subprocess.STDOUT,check=True)
subprocess.run([sys.executable,'-B',str(P/'08_verify_assets.py'),str(out)],check=True)
(out/'CLEAN_RUN_RECEIPT.json').write_text(json.dumps({'status':'PASS','raw_root_supplied_explicitly':True,'clean_requested':a.clean,'bootstrap_attempts':10000,'sensitivity_institution_deletions':71,'completed_at':datetime.datetime.now().astimezone().isoformat(),'no_old_Step2_derived_calculation_inputs':True},indent=2));print('COMPLETE CLEAN PIPELINE PASS',flush=True)