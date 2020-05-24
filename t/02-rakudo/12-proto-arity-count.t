use Test;
plan +my @protos := all-the-protos;

# https://github.com/rakudo/rakudo/issues/1739
for @protos -> \p {
    my $name := p.name // '<Unknown name>';
    without p.dispatchees {
        skip "`$name` is not a multi";
        next;
    }

    # ensure that proto has a Mu param if candidates have 'em, otherwise,
    # they're not going to fit through
    my @mu-pos-proto;
    my $mu-proto-capture-at = Inf;
    for p.signature.params.grep({.positional or .capture}).kv -> \idx, \param {
        $mu-proto-capture-at = idx if param.capture;
        next unless param.type =:= Mu;
        @mu-pos-proto[idx] = "at pos {idx}";
    }
    my @mu-pos-cand;
    for p.candidates -> \candidate {
        for candidate.signature.params.grep({.positional}).kv -> \idx, \param {
            next if param.type !=:= Mu or idx ≥ $mu-proto-capture-at;
            @mu-pos-cand[idx] = "at pos {idx}";
        }
    }

    my $count := p.dispatchees.map(*.count).max;
    my $arity := p.dispatchees.map(*.arity).min;
    my $named-slurpy-or-capture
    := so p.signature.params.grep: {.named and .slurpy or .capture};
    is-deeply {
        arity => p.arity, count => p.count, :$named-slurpy-or-capture,
        :mu-pos(@mu-pos-proto),
    }, { :$arity, :$count, :named-slurpy-or-capture, :mu-pos(@mu-pos-cand) },
      "`\&$name`'s proto's .count and .arity are good"
    or diag qq:to/END/
        GOT      == stuff of the proto
        EXPECTED == stuff of the candidates
        FAILED for `\&$name`!
          proto's .arity ({p.arity}) must match the minimum .arity of the candidates ($arity)
          proto's .count ({p.count}) must match the maximum .count of the candidates ($count)
          proto's signature must have slurpy named param or capture (it {
              $named-slurpy-or-capture and 'does' or 'does not'})
          proto's Mu pos args must match the candidates (they {
              @mu-pos-proto eqv @mu-pos-cand and 'do' or 'do not'})
          proto's location: {p.file.subst: /'SETTING::'/, ''}:{p.line}

        CANDIDATES ARE:
          {
              join "\n", p.candidates.sort(*.signature.gist).map: {
                  "{.signature.gist}, arity = {.arity}, count = {.count}"
              }
          }
        PROTO's SIGNATURE IS:
          {p.signature.gist}

        # END atom highlights workaround
        END
}


sub all-the-protos {
    &abs,
    &acos,
    &acosec,
    &acosech,
    &acosh,
    &acotan,
    &acotanh,
    &all,
    &any,
    &append,
    &asec,
    &asech,
    &asin,
    &asinh,
    &atan,
    &atan2,
    &atanh,
    &atomic-add-fetch,
    &atomic-assign,
    &atomic-dec-fetch,
    &atomic-fetch,
    &atomic-fetch-add,
    &atomic-fetch-dec,
    &atomic-fetch-inc,
    &atomic-fetch-sub,
    &atomic-inc-fetch,
    &atomic-sub-fetch,
    &await,
    &bag,
    &cache,
    &cas,
    &categorize,
    &ceiling,
    &chars,
    &chdir,
    &chmod,
    &chomp,
    &chop,
    &chr,
    &chrs,
    &circumfix:<[ ]>,
    &circumfix:<{ }>,
    &cis,
    &classify,
    &close,
    &comb,
    &combinations,
    &copy,
    &cos,
    &cosec,
    &cosech,
    &cosh,
    &cotan,
    &cotanh,
    &deepmap,
    &defined,
    &die,
#    &dir,
    &duckmap,
    &elems,
    &end,
    &EVAL,
    &EVALFILE,
    &exit,
    &exp,
    &expmod,
    &fail,
    &fc,
    &first,
    &flat,
    &flip,
    &floor,
    &full-barrier,
    &get,
    &getc,
    &gethostname,
    &gist,
    &goto,
    &grep,
    &hash,
    &index,
    &indices,
    &indir,
    &infix:<^^>,
    &infix:<^>,
    &infix:<^..^>,
    &infix:<^..>,
    &infix:<~^>,
    &infix:<~~>,
    &infix:<~>,
    &infix:<~|>,
    &infix:<~&>,
    &infix:<<(<=)>>,
    &infix:<<(<)>>,
    &infix:<<(<+)>>,
    &infix:<<(>=)>>,
    &infix:<<(>)>>,
    &infix:<<(>+)>>,
    &infix:<=~=>,
    &infix:<===>,
    &infix:<==>,
    &infix:<=:=>,
    &infix:<|>,
    &infix:<||>,
    &infix:<->,
    &infix:<,>,
    &infix:<!~~>,
    &infix:<!=>,
    &infix:<?^>,
    &infix:<?|>,
    &infix:<?&>,
    &infix:</>,
    &infix:<//>,
    &infix:<..^>,
    &infix:<..>,
    &infix:<...^>,
    &infix:<...>,
    &infix:<(^)>,
    &infix:<(|)>,
    &infix:<(-)>,
    &infix:<(.)>,
    &infix:<(&)>,
    &infix:<(+)>,
    &infix:<*>,
    &infix:<**>,
    &infix:<&>,
    &infix:<&&>,
    &infix:<%>,
    &infix:<%%>,
    &infix:<+^>,
    &infix:<+>,
    &infix:<+|>,
    &infix:<+&>,
    &infix:<…^>,
    &infix:<⚛=>,
    &infix:<⊄>,
    &infix:<⊃>,
    &infix:<⊅>,
    &infix:<∉>,
    &infix:<∋>,
    &infix:<∌>,
    &infix:<…>,
    &infix:<⊈>,
    &infix:<⊇>,
    &infix:<⊉>,
    &infix:<≼>,
    &infix:<≽>,
    &infix:<⚛-=>,
    &infix:<⚛+=>,
    &infix:«<=>»,
    &infix:«<=»,
    &infix:«<»,
    &infix:«=>»,
    &infix:«>=»,
    &infix:«>»,
    &infix:«+<»,
    &infix:«+>»,
    &infix:<after>,
    &infix:<and>,
    &infix:<andthen>,
    &infix:<before>,
    &infix:<but>,
    &infix:<cmp>,
    &infix:<coll>,
    &infix:<(cont)>,
    &infix:<div>,
    &infix:<does>,
    &infix:<(elem)>,
    &infix:<eq>,
    &infix:<eqv>,
    &infix:<gcd>,
    &infix:<ge>,
    &infix:<gt>,
    &infix:<lcm>,
    &infix:<le>,
    &infix:<leg>,
    &infix:<lt>,
    &infix:<max>,
    &infix:<min>,
    &infix:<minmax>,
    &infix:<mod>,
    &infix:<ne>,
    &infix:<notandthen>,
    &infix:<o>,
    &infix:<or>,
    &infix:<orelse>,
    &infix:<unicmp>,
    &infix:<x>,
    &infix:<X>,
    &infix:<xor>,
    &infix:<xx>,
    &infix:<Z>,
    &is-prime,
    &item,
    &join,
    &keys,
    &kv,
    &last,
    &lc,
    &lines,
    &link,
    &list,
    &log,
    &log10,
    &log2,
    &lsb,
    &make,
    &map,
    &max,
    &min,
    &minmax,
    &mix,
    &mkdir,
    &move,
    &msb,
    &next,
    &nodemap,
    &none,
    &not,
    &note,
    &one,
    &open,
    &ord,
    &ords,
    &pair,
    &pairs,
    &parse-base,
    &permutations,
    &pick,
    &pop,
    &postcircumfix:<[ ]>,
    &postcircumfix:<[; ]>,
    &postcircumfix:<{ }>,
    &postcircumfix:<{; }>,
    &postfix:<-->,
    &postfix:<++>,
    &postfix:<ⁿ>,
    &postfix:<⚛-->,
    &postfix:<⚛++>,
    &postfix:<i>,
    &prefix:<^>,
    &prefix:<~^>,
    &prefix:<~>,
    &prefix:<|>,
    &prefix:<->,
    &prefix:<-->,
    &prefix:<--⚛>,
    &prefix:<!>,
    &prefix:<?^>,
    &prefix:<?>,
    &prefix:<+^>,
    &prefix:<+>,
    &prefix:<++>,
    &prefix:<++⚛>,
    &prefix:<⚛>,
    &prefix:<not>,
    &prefix:<so>,
    &prepend,
    &print,
    &printf,
    &produce,
    &prompt,
    &push,
    &put,
    &rand,
    &redo,
    &reduce,
    &rename,
    &repeated,
    &return,
    &return-rw,
    &reverse,
    &rindex,
    &rmdir,
    &roll,
    &roots,
    &rotate,
    &round,
    &roundrobin,
    &run,
    &samecase,
    &samemark,
    &say,
    &sec,
    &sech,
    &set,
    &shell,
    &shift,
    &sign,
    &signal,
    &sin,
    &sinh,
    &sleep,
    &sleep-timer,
    &sleep-until,
    &slip,
#    &slurp,
    &so,
    &sort,
    &splice,
    &split,
    &sprintf,
#    &spurt,
    &sqrt,
    &squish,
    &srand,
    &subbuf-rw,
    &substr,
    &substr-rw,
    &succeed,
    &sum,
    &symlink,
    &take,
    &take-rw,
    &tan,
    &tanh,
    &tc,
    &tclc,
    &trait_mod:<does>,
    &trait_mod:<handles>,
    &trait_mod:<hides>,
    &trait_mod:<is>,
    &trait_mod:<of>,
    &trait_mod:<returns>,
    &trait_mod:<trusts>,
    &trait_mod:<will>,
    &trim,
    &trim-leading,
    &trim-trailing,
    &truncate,
    &uc,
    &UNBASE,
    &undefine,
    &unimatch,
    &uniname,
    &uninames,
    &uniparse,
    &uniprop,
    &uniprop-bool,
    &uniprop-int,
    &uniprops,
    &uniprop-str,
    &unique,
    &unival,
    &univals,
    &unlink,
    &unpolar,
    &unshift,
    &values,
    &warn,
    &wordcase,
    &words,
}
