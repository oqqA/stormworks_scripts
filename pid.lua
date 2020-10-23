function pid(p,i,d,ci)
    return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,
        run=function(s,sp,pv)
            local E,D,I
            E = sp-pv
            D = E-s.E
            I = clamp(E*s.i+s.I,-s.ci,s.ci)
            s.E = E
            s.I = I
            return E*s.p+s.I+D*s.d
        end
    }
end

function pid(p,i,d,ci)return{p=p,i=i,d=d,ci=ci,E=0,D=0,I=0,run=function(s,sp,pv)local E,D,I;E=sp-pv;D=E-s.E;I=math.clamp(E*s.i+s.I,-s.ci,s.ci);s.E=E;s.I=I;return E*s.p+s.I+D*s.d end}end