truncate table chips_stg.px_tree_flattened;

insert into chips_stg.px_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node_num,
    tree_node ,
    l1_tree_node_num, 
    l1_tree_node
)
    select 
        setid, 
        tree_name,
        effdt,
        tree_node_num,
        tree_node,
        tree_node_num as l1_tree_node_num, 
        tree_node as l1_tree_node
    from chips_stg.pstreenode nd
    where nd.tree_name = 'DEPT_SECURITY' 
        and nd.setid <> 'COMMN' 
        and nd.setid <> 'ST000'
        and nd.effdt < sysdate
        and tree_level_num = 1
;

insert into chips_stg.px_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    l1_tree_node,l1_tree_node_num, 
    l2_tree_node,l2_tree_node_num, 
    l3_tree_node,l3_tree_node_num, 
    l4_tree_node,l4_tree_node_num, 
    l5_tree_node,l5_tree_node_num, 
    l6_tree_node,l6_tree_node_num, 
    l7_tree_node,l7_tree_node_num
)
    select 
        l2.setid as setid,
        l2.tree_name as tree_name,
        l2.effdt as effdt,
        l2.tree_node as tree_node,
        l2.tree_node_num as tree_node_num,  
        ptf.l1_tree_node,
        ptf.l1_tree_node_num,
        l2.tree_node as l2_tree_node ,
        l2.tree_node_num as l2_tree_node_num,
        null as l3_tree_node, 
        null as l3_tree_node_num,
        null as l4_tree_node, 
        null as l4_tree_node_num,
        null as l5_tree_node, 
        null as l5_tree_node_num,
        null as l6_tree_node, 
        null as l6_tree_node_num,
        null as l7_tree_node, 
        null as l7_tree_node_num
    from (
        select 
            setid, 
            tree_name,
            effdt,
            tree_node_num,
            tree_node ,
            parent_node_num,
            tree_node_num as l2_tree_node_num, 
            tree_node as l2_tree_node
        from chips_stg.pstreenode nd 
        where  
            ND.TREE_NAME='DEPT_SECURITY' 
            AND ND.SETID <> 'COMMN' 
            AND ND.SETID  <> 'ST000'
            AND ND.effdt<sysdate 		   
            AND tree_level_num=2
    ) l2, (
        select setid,effdt,tree_name,tree_node_num, l1_tree_node_num,l1_tree_node 
        from chips_stg.px_tree_flattened
    ) ptf
    where 
        l2.setid=ptf.setid  
        and l2.effdt=ptf.effdt 
        and l2.tree_name=ptf.tree_name
        and l2.parent_node_num=ptf.tree_node_num
;

insert into chips_stg.px_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    l1_tree_node,
    l1_tree_node_num, 
    l2_tree_node,
    l2_tree_node_num, 
    l3_tree_node,
    l3_tree_node_num, 
    l4_tree_node,
    l4_tree_node_num, 
    l5_tree_node,
    l5_tree_node_num, 
    l6_tree_node,
    l6_tree_node_num, 
    l7_tree_node,
    l7_tree_node_num
)
    select 
        L3.setid as setid,
        L3.tree_name as tree_name,
        L3.effdt as effdt,
        L3.tree_node as tree_node,
        L3.tree_node_num as tree_node_num,  
        PTF.L1_tree_node,
        PTF.L1_tree_node_num,
        PTF.L2_tree_node,
        PTF.L2_tree_node_num,
        L3.tree_node as L3_tree_node ,
        L3.tree_node_num as L3_tree_node_num,
        NULL as L4_tree_node, 
        NULL as L4_tree_node_num,
        NULL as L5_tree_node, 
        NULL as L5_tree_node_num,
        NULL as L6_tree_node, 
        NULL as L6_tree_node_num,
        NULL as L7_tree_node, 
        NULL as L7_tree_node_num
    FROM (
        select 
            setid, 
            tree_name,
            effdt,
            tree_node_num,
            tree_node ,
            parent_node_num,
            tree_node_num as L3_tree_node_num, 
            tree_node as L3_tree_node
		from chips_stg.pstreenode  ND 
        where  
            ND.TREE_NAME = 'DEPT_SECURITY' 
            AND ND.effdt < sysdate 		   
            AND ND.SETID <> 'COMMN' 
            AND ND.SETID <> 'ST000'
            AND tree_level_num = 3
		) L3, (
            select setid, effdt, tree_name, tree_node_num, L1_tree_node_num, L1_tree_node,
		        L2_tree_node_num,L2_tree_node 
            from chips_stg.PX_Tree_Flattened
		) PTF
    where 
        L3.setid=PTF.setid  
        and L3.effdt=PTF.effdt 
        and L3.tree_name=PTF.tree_name
        and L3.parent_node_num=PTF.tree_node_num
; 

INSERT INTO chips_stg.PX_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    L1_tree_node,
    L1_tree_node_num, 
    L2_tree_node,
    L2_tree_node_num, 
    L3_tree_node,
    L3_tree_node_num, 
    L4_tree_node,
    L4_tree_node_num, 
    L5_tree_node,
    L5_tree_node_num, 
    L6_tree_node,
    L6_tree_node_num, 
    L7_tree_node,
    L7_tree_node_num
)
    select 
        L4.setid as setid,
        L4.tree_name as tree_name,
        L4.effdt as effdt,
        L4.tree_node as tree_node,
        L4.tree_node_num as tree_node_num,  
        PTF.L1_tree_node,
        PTF.L1_tree_node_num,
        PTF.L2_tree_node,
        PTF.L2_tree_node_num,
        PTF.L3_tree_node,
        PTF.L3_tree_node_num,
        L4.tree_node as L4_tree_node ,
        L4.tree_node_num as L4_tree_node_num,
        NULL as L5_tree_node, 
        NULL as L5_tree_node_num,
        NULL as L6_tree_node, 
        NULL as L6_tree_node_num,
        NULL as L7_tree_node, 
        NULL as L7_tree_node_num
    FROM (
        select 
            setid, 
            tree_name,
            effdt,
            tree_node_num,
            tree_node ,
            parent_node_num,
            tree_node_num as L4_tree_node_num, 
            tree_node as L4_tree_node
		from chips_stg.pstreenode ND 
        where  
            ND.TREE_NAME='DEPT_SECURITY' 
            AND ND.effdt<sysdate 		   
            AND ND.SETID <> 'COMMN' 
            AND ND.SETID  <> 'ST000'
            AND tree_level_num=4
	) L4, (
        select setid,effdt,tree_name,tree_node_num, L1_tree_node_num,L1_tree_node ,
		    L2_tree_node_num,L2_tree_node ,L3_tree_node_num,L3_tree_node 
        from chips_stg.PX_Tree_Flattened
	) PTF
    where 
        L4.setid=PTF.setid 
        and L4.effdt=PTF.effdt 
        and L4.tree_name=PTF.tree_name
        and L4.parent_node_num=PTF.tree_node_num
;

INSERT INTO chips_stg.PX_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    l1_tree_node,
    l1_tree_node_num, 
    l2_tree_node,
    l2_tree_node_num, 
    l3_tree_node,
    l3_tree_node_num, 
    l4_tree_node,
    l4_tree_node_num, 
    l5_tree_node,
    l5_tree_node_num, 
    l6_tree_node,
    l6_tree_node_num, 
    l7_tree_node,
    l7_tree_node_num
)
select 
    L5.setid as setid,
    L5.tree_name as tree_name,
    L5.effdt as effdt,
    L5.tree_node as tree_node,
    L5.tree_node_num as tree_node_num,  
    PTF.L1_tree_node,
    PTF.L1_tree_node_num,
    PTF.L2_tree_node,
    PTF.L2_tree_node_num,
    PTF.L3_tree_node,
    PTF.L3_tree_node_num,
    PTF.L4_tree_node,
    PTF.L4_tree_node_num,
    L5.tree_node as L5_tree_node ,
    L5.tree_node_num as L5_tree_node_num,
    NULL as L6_tree_node, 
    NULL as L6_tree_node_num,
    NULL as L7_tree_node, 
    NULL as L7_tree_node_num
FROM (
    select 
        setid, 
        tree_name,
        effdt,
        tree_node_num,
        tree_node ,
        parent_node_num,
        tree_node_num as L5_tree_node_num, 
        tree_node as L5_tree_node
    from chips_stg.pstreenode  ND 
    where  
        ND.TREE_NAME='DEPT_SECURITY' 
        AND ND.SETID <> 'COMMN' 
        AND ND.SETID  <> 'ST000'
        AND ND.effdt<sysdate 			   
        AND tree_level_num=5
) L5, (
    select 
        setid,
        effdt,
        tree_name,
        tree_node_num, 
        L1_tree_node_num,
        L1_tree_node ,
        L2_tree_node_num,
        L2_tree_node ,
        L3_tree_node_num,
        L3_tree_node,
        L4_tree_node_num,
        L4_tree_node 
    from chips_stg.PX_Tree_Flattened
) PTF
where 
    L5.setid=PTF.setid 
    and L5.effdt=PTF.effdt 
    and L5.tree_name=PTF.tree_name
    and L5.parent_node_num=PTF.tree_node_num
;

INSERT INTO chips_stg.PX_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    L1_tree_node,
    L1_tree_node_num, 
    L2_tree_node,
    L2_tree_node_num, 
    L3_tree_node,
    L3_tree_node_num, 
    L4_tree_node,
    L4_tree_node_num, 
    L5_tree_node,
    L5_tree_node_num, 
    L6_tree_node,
    L6_tree_node_num, 
    L7_tree_node,
    L7_tree_node_num
)
    select 
        L6.setid as setid,
        L6.tree_name as tree_name,
        L6.effdt as effdt,
        L6.tree_node as tree_node,
        L6.tree_node_num as tree_node_num,  
        PTF.L1_tree_node,
        PTF.L1_tree_node_num,
        PTF.L2_tree_node,
        PTF.L2_tree_node_num,
        PTF.L3_tree_node,
        PTF.L3_tree_node_num,
        PTF.L4_tree_node,
        PTF.L4_tree_node_num,
        PTF.L5_tree_node,
        PTF.L5_tree_node_num,
        L6.tree_node as L6_tree_node ,
        L6.tree_node_num as L6_tree_node_num,
        NULL as L7_tree_node, 
        NULL as L7_tree_node_num
    FROM (
        select 
            setid, 
            tree_name,
            effdt,
            tree_node_num,
            tree_node ,
            parent_node_num,
            tree_node_num as L6_tree_node_num, 
            tree_node as L6_tree_node
        from chips_stg.pstreenode ND 
        where  
            ND.TREE_NAME='DEPT_SECURITY' 
            AND ND.effdt<sysdate 		   
            AND ND.SETID <> 'COMMN' 
            AND ND.SETID  <> 'ST000'
            AND tree_level_num=6
    ) L6, (
        select setid,effdt,tree_name,tree_node_num, L1_tree_node_num,
            L1_tree_node ,L2_tree_node_num,L2_tree_node ,L3_tree_node_num,
            L3_tree_node,L4_tree_node_num,L4_tree_node,L5_tree_node_num,L5_tree_node 
        from chips_stg.PX_Tree_Flattened
    ) PTF
    where 
        L6.setid=PTF.setid 
        and L6.effdt=PTF.effdt 
        and L6.tree_name=PTF.tree_name
        and L6.parent_node_num=PTF.tree_node_num
;

INSERT INTO chips_stg.PX_tree_flattened (
    setid, 
    tree_name,
    effdt,
    tree_node ,
    tree_node_num,
    L1_tree_node,
    L1_tree_node_num, 
    L2_tree_node,
    L2_tree_node_num, 
    L3_tree_node,
    L3_tree_node_num, 
    L4_tree_node,
    L4_tree_node_num, 
    L5_tree_node,
    L5_tree_node_num, 
    L6_tree_node,
    L6_tree_node_num, 
    L7_tree_node,
    L7_tree_node_num
)
select 
    L7.setid as setid,
    L7.tree_name as tree_name,
    L7.effdt as effdt,
    L7.tree_node as tree_node,
    L7.tree_node_num as tree_node_num,  
    PTF.L1_tree_node,
    PTF.L1_tree_node_num,
    PTF.L2_tree_node,
    PTF.L2_tree_node_num,
    PTF.L3_tree_node,
    PTF.L3_tree_node_num,
    PTF.L4_tree_node,
    PTF.L4_tree_node_num,
    PTF.L5_tree_node,
    PTF.L5_tree_node_num,
    PTF.L6_tree_node,
    PTF.L6_tree_node_num,
    L7.tree_node as L7_tree_node ,
    L7.tree_node_num as L7_tree_node_num
FROM (
    select 
        setid, 
        tree_name,
        effdt,
        tree_node_num,
        tree_node ,
        parent_node_num,
        tree_node_num as L7_tree_node_num, 
        tree_node as L7_tree_node
    from chips_stg.pstreenode ND 
    where ND.TREE_NAME='DEPT_SECURITY' 
        AND ND.effdt<sysdate 		   
        AND ND.SETID <> 'COMMN' 
        AND ND.SETID  <> 'ST000'
        AND tree_level_num=7
) L7, (
    select setid,effdt,tree_name,tree_node_num, L1_tree_node_num,L1_tree_node ,
        L2_tree_node_num,L2_tree_node ,L3_tree_node_num,L3_tree_node,
        L4_tree_node_num,L4_tree_node,L5_tree_node_num,L5_tree_node,
        L6_tree_node_num,L6_tree_node 
    from chips_stg.PX_Tree_Flattened
) PTF
where 
    L7.setid=PTF.setid 
    and L7.effdt=PTF.effdt 
    and L7.tree_name=PTF.tree_name
    and L7.parent_node_num=PTF.tree_node_num
;

commit;
