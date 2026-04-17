package main;

import com.sun.source.tree.Tree;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class ExprArith {
    protected Arbre arbre;
    protected final HashMap<String, Double> associations;
    static final List<String> operators = Arrays.asList("+", "/", "-", "*");

    public ExprArith(Arbre a) {
        this.arbre = a;
        this.associations = new HashMap<>();
    }

    public void associerValeur(String symbole, double valeur) {
        if (symbole == null) {
            throw new IllegalArgumentException("Attempt to use null symbol");
        }
        this.associations.put(symbole, valeur);
    }

    public double valeur(String symbol) {
        if (symbol == null) {
            throw new IllegalArgumentException("Attempt to fetch null symbol");
        }
        if (!this.associations.containsKey(symbol)) {
            throw new IllegalArgumentException("Attempt to fetch unknown symbol " + symbol);
        }
        return this.associations.get(symbol);
    }

    private double recursiveEvaluation(Arbre root) {
        if (root.estVide())
            throw new RuntimeException("NULL ROOT TREE");
        // Value?
        Arbre gauche = root.arbreG();
        Arbre droit = root.arbreD();
        Object racine = root.racine();
        if (racine.getClass() != String.class)
            throw new RuntimeException("INVALID ROOT TYPE");
        String renter = (String) racine;

        if (gauche.estVide() || droit.estVide()) {
            // We must be a value, let's try
            try {
                return Double.parseDouble(renter);
            } catch (NumberFormatException e) {
                // Welp
            }
            return this.valeur(renter);
        } else {
            double dgauche = recursiveEvaluation(gauche);
            double ddroite = recursiveEvaluation(droit);
            switch (renter) {
                case "+" : { return dgauche+ddroite; }
                case "-" : { return dgauche - ddroite; }
                case "/" : { return dgauche / ddroite; }
                case "*" : { return dgauche * ddroite; }
                default : {
                    throw new IllegalArgumentException("UNKNOWN OPERATION " + renter);
                }
            }
        }
    }

    public double evaluer() {
        // Evaluate every node
        return this.recursiveEvaluation(this.arbre);
    }

    public String toString() {
        // Build a string list
        ArrayList<String> lr = new ArrayList<>(
                Arrays.asList(this.arbre.toString().split(" ")));
        // Now let's pop and hope nothing was the empty string in there
        ArrayList<String> stack = new ArrayList<>();

        while (lr.size() > 0) {
            String token = lr.remove(0);
            // Is it one of the four basic operators?
            if (operators.contains(token)) {
                // Pull two tokens from the stack
                String rtoken = stack.remove(stack.size()-1);
                // Is it already an expression? If so, add parens
                if (rtoken.contains(" ")) {
                    rtoken = "( " + rtoken + " )";
                }
                String ltoken = stack.remove(stack.size()-1);
                // Is it already an expression? If so, add parens
                if (ltoken.contains(" ")) {
                    ltoken = "( " + ltoken + " )";
                }
                String res = ltoken + " " + token + " " + rtoken;
                stack.add(res);
            } else {
                // It's an argument, push it
                stack.add(token);
            }
        }
        return stack.remove(stack.size()-1);
    }

    private Arbre recursiveSimplify(Arbre root) {
        Arbre gauche = root.arbreG();
        Arbre droit = root.arbreD();

        Object racine = root.racine();
        if (racine.getClass() != String.class)
            throw new RuntimeException("BAD RACINE");
        String ricin = (String)racine;

        // Simplify the right
        if (gauche.estVide() || droit.estVide()) {
            // Root value, we can't exactly simplify
            return root;
        } else {
            Arbre new_left = recursiveSimplify(gauche);
            Arbre new_right = recursiveSimplify(droit);

            TreeTwo res = new TreeTwo(root.racine());
            // Try to simplify and if anything goes wrong return the unsimplified tree
            if (new_left.hauteur() > 0 || new_right.hauteur() > 0) {
                // Failed because the "simplified" left tree is not a single node
                res.modifArbreD(new_right);
                res.modifArbreG(new_left);
                return res;
            }
            // Then try to convert the objects
            Object nlo = new_left.racine();
            if (nlo.getClass() != String.class)
                throw new RuntimeException("INVALID NLO CLASS");
            String nls = (String)nlo;
            Object nro = new_right.racine();
            if (nro.getClass() != String.class)
                throw new RuntimeException("INVALID NRO CLASS");
            String nrs = (String)nro;

            // Try and convert both to double and compute
            double nld = 0;
            try {
                nld = Double.parseDouble(nls);
            } catch (NumberFormatException e) {
                if (this.associations.containsKey(nls))
                    nld = this.associations.get(nls);
                else {
                    res.modifArbreD(new_right);
                    res.modifArbreG(new_left);
                    return res;
                }
            }

            double nrd = 0;
            try {
                nrd = Double.parseDouble(nrs);
            } catch (NumberFormatException e) {
                if (this.associations.containsKey(nrs))
                    nrd = this.associations.get(nrs);
                else {
                    res.modifArbreD(new_right);
                    res.modifArbreG(new_left);
                    return res;
                }
            }

            switch (ricin) {
                case "+": { return new TreeTwo("" + (nld+nrd)); }
                case "-": { return new TreeTwo("" + (nld-nrd)); }
                case "*": { return new TreeTwo("" + (nld*nrd)); }
                case "/": { return new TreeTwo("" + (nld/nrd)); }
                default: { throw new RuntimeException("WHAT THE FUCK"); }
            }
        }
    }

    public Arbre simplifier() {
        return recursiveSimplify(this.arbre);
    }
}
