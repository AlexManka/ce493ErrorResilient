module razorflipflop (clk, d, reset, q, error);
    input clk;
    input d, reset;
    output q, error;

    wire c1, c2, dat1, n, dat3;
    wire dc0, dc1, dc3, dc;
    wire d0, d1, d2, d3, td0, td1, td2, td3, td4, td5, td6;
    wire low, high;


    //I wired top part, bottom right, bottom left
    //columns are next to each other for the most part

    not_gate top1(.x(clk), .z(c1));

    not_gate top2(.x(c1), .z(c2));
    not_gate data(.x(d), .z(dat1));

    pmos topp(dat1, n, c2);
    nmos topn(n, dat1, c1);

    not_gate r1(.x(n), .z(dat3));
    not_gate r2(.x(dat3), .z(n));
    not_gate r3(.x(n), .z(q));

    assign low = 0;
    assign high = 1;



    //Detection Clock (DC) generator
    nmos dc00(dc0, high, clk);
    pmos dc01(low, dc0, clk);

    pmos dc10(dc0, dc1, high);
    nmos dc11(dc1, dc0, low);

    nmos dc20(dc, high, dc1);
    nmos dc21(dc, high, clk);
    pmos dc22(dc3, dc, dc1);
    pmos dc23(low, dc3, clk);



    //Transition Detector (TD)
    //nmos(.drain(), .source(), .gate());
    // nmos output is drain, pmos vice versa
    nmos td00(d0, high, n);
    pmos td01(low, d0, n);

    nmos td10(d1, high, d0);
    pmos td11(low, d1, d0);

    //Rising Transition delay chain
    //next 4 lines in row order
    nmos td20(td0, high, d1);
    pmos td21(low, td0, d1);
    pmos td22(td0, d3, high);
    nmos td23(d3, td0, low);

    pmos td30(d1, d2, high);
    nmos td31(d2, d1, low);


    //ERROR
    nmos td40(td1, high, reset);
    pmos td41(td2, td1, d0);
    pmos td42(td1, td3, d1);
    pmos td43(td4, td2, d2);
    pmos td44(td3, td4, d3);
    pmos td45(td4, td5, dc);
    pmos td46(low, td5, reset);

    not_gate td50(.x(td1), .z(error));
    not_gate td51(.x(td1), .z(td6));
    not_gate td52(.x(td6), .z(td1));
      
endmodule 