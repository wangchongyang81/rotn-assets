import pathlib, sys
from huggingface_hub import HfApi
loc={str(p.relative_to('art/realms')) for p in pathlib.Path('art/realms').rglob('*.png')}
rem={f[len('realms/'):] for f in HfApi().list_repo_files('wangchongyang81/rotn-pilot') if f.startswith('realms/') and f.endswith('.png')}
print('local',len(loc),'remote',len(rem))
print('missing',sorted(loc-rem)[:3])
print('extra',sorted(rem-loc)[:3])
print('parity','OK' if loc==rem else 'MISMATCH')
sys.exit(0 if loc==rem else 1)
