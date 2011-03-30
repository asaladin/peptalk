load 2o02.pdb
select bound, 2o02 and chain A
load 2bq0.pdb
select unbound, 2bq0 and chain A
align polymer and name ca and unbound, polymer and name ca and bound, quiet=0, object="aln_bound_unbound", reset=1
select peptide, (2o02 within 8 of unbound) and not bound
deselect
color magenta, peptide
color yellow, bound
color blue, unbound
show_as cartoon, all
orient bound
create unb_surface, unbound; color white, unb_surface; set transparency, 0.6, unb_surface; show_as surface, unb_surface;