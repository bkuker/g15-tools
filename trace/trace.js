import input from "../programs/videoMusic/AStart.trace.json" with { type: 'json' };
import cytoscape from 'cytoscape';

//Add IDs
let trace = input;
let arp;
for (let t of trace) {
    if ( t.cmdLoc == 127 ){
        t.id = "AR:" + arp.id;
    } else {
        t.id = t.cd + ":" + t.cmdLoc;
    }
    arp = t;
}

trace = uniquifyArray(trace);
//Create an array of pairs
let edges = [];
for (let i = 0; i < trace.length - 1; i++) {
    let cur = trace[i];
    let next = trace[i + 1];
    edges.push({
        id: `${cur.id}-${next.id}`,
        cur,
        next,
        source: cur.id,
        target: next.id
    });

    /*
    if ( cur.returnAddress ){
        edges.push({
            id: `${cur.id}-${cur.cd}:${cur.returnAddress}`,
            source: cur.id,
            target: `${cur.cd}:${cur.returnAddress}`
        });
    }*/
}
edges = uniquifyArray(edges);

edges = uniqueById(edges);

console.log(edges);

var cy = cytoscape({
    container: document.getElementById('cy'),
    elements: [
        ...uniqueById(trace).map(t => { return { data: t }; }),
        ...uniqueById(edges).map(e => {
            if (e.cur?.mark) {
                return { data: e, classes: "subroutine mark" };
            } else if (e.cur?.return) {
                return { data: e, classes: "subroutine return" };
            }
            return { data: e };
        })
    ],
    style: [
        {
            selector: 'node',
            style: {
                'background-color': '#666',
                'label': 'data(id)'
            }
        },

        {
            selector: 'edge',
            style: {
                'width': 6,
                'line-color': '#ccc',
                'color': '#777',
                'target-arrow-color': '#ccc',
                'target-arrow-shape': 'triangle',
                'curve-style': 'bezier',
                'label': 'data(count)'
            }
        },

        {
            selector: 'edge[count = 1]',
            style: {
                'width': 3,
                'label': ''
            }
        }
    ]
});

const excludedEdges = cy.edges('.subroutine').remove(); // Temporarily remove them

// Apply layout
cy.layout({
    name: 'breadthfirst', // or 'dagre', 'klay'
    directed: true,
    spacingFactor: 1.2
}).run();

// Re-add excluded edges
cy.add(excludedEdges);


function uniqueById(aa) {
    let m = new Map();
    for (let t of aa)
        m.set(t.id, t);
    return Array.from(m.values());
}

//Takes an array of objects and de-duplicated
//them based on their JSON String value.
//Returned array has "same" objects in the same
//order, but if two values in the array "looked"
//the same in the input they refer to the same
//object in the output.
//
//Adds an ID and count to each one.
function uniquifyArray(aa) {
    let ret = [];
    let tt = new Map();
    for (let t of aa) {
        t.count = 1;
        let id = t.id;
        if (tt.has(id)) {
            tt.get(id).count++;
        } else {
            tt.set(id, t);
        }
        ret.push(tt.get(id));
    }
    return ret;
}