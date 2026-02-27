import { useState, useEffect } from "react";

const COLORS = {
  crea : "#FFF8F0",
  beige: "#F5E6D3",
  warmWhite: "#FFFCF7",
  softBrown: "#8B7355",
  darkBrown: "#4A3728",
  caramel: "#C4956A",
  golden: "#D4A574",
  accent: "#B8860B",
  lightGold: "#F0DFC0",
  terracotta: "#C07850",
  sage: "#A8B89C",
  roseDust: "#C9A9A6",
  text: "#3D2B1F",
  textLight: "#7A6B5D",
  white: "#FFFFFF",
  shadow: "rgba(74, 55, 40, 0.08)",
};

const categories = [
  { id: "breads", label: "Breads", icon: "🍞", count: 12 },
  { id: "pastries", label: "Pastries", icon: "🥐", count: 18 },
  { id: "cakes", label: "Cakes", icon: "🎂", count: 9 },
  { id: "cookies", label: "Cookies", icon: "🍪", count: 15 },
];

const products = [
  { id: 1, name: "Sourdough Boule", category: "breads", price: 8.50, rating: 4.9, reviews: 124, image: "🍞", badge: "Bestseller", description: "Our signature 48-hour fermented sourdough with a crackling crust and tender, airy crumb. Made with heritage wheat flour.", tags: ["Organic", "Vegan"], time: "48hr ferment" },
  { id: 2, name: "Pain au Chocolat", category: "pastries", price: 5.25, rating: 4.8, reviews: 89, image: "🥐", badge: "New", description: "Buttery, flaky layers wrapped around two bars of premium Belgian dark chocolate. Baked fresh every morning.", tags: ["Contains Dairy"], time: "Fresh daily" },
  { id: 3, name: "Raspberry Tart", category: "pastries", price: 7.00, rating: 4.7, reviews: 67, image: "🫐", badge: null, description: "Crisp almond pastry shell filled with vanilla custard and topped with fresh raspberries and a light glaze.", tags: ["Contains Nuts"], time: "Made to order" },
  { id: 4, name: "Chocolate Layer Cake", category: "cakes", price: 42.00, rating: 5.0, reviews: 203, image: "🎂", badge: "Popular", description: "Three layers of rich dark chocolate sponge, filled with ganache and finished with Belgian chocolate shavings.", tags: ["Gluten-Free Option"], time: "24hr notice" },
  { id: 5, name: "Ciabatta Loaf", category: "breads", price: 6.75, rating: 4.6, reviews: 55, image: "🥖", badge: null, description: "Italian-style bread with an incredibly open crumb and crispy, olive oil-brushed crust. Perfect for sandwiches.", tags: ["Vegan"], time: "Baked daily" },
  { id: 6, name: "Almond Croissant", category: "pastries", price: 6.00, rating: 4.9, reviews: 156, image: "🥐", badge: "Bestseller", description: "Day-old croissant filled with almond frangipane, topped with sliced almonds and powdered sugar.", tags: ["Contains Nuts", "Contains Dairy"], time: "Limited daily" },
];

const recentOrders = [
  { id: "#2847", date: "Today, 10:32 AM", items: [{ name: "Sourdough Boule", image: "🍞", qty: 1 }, { name: "Almond Croissant", image: "🥐", qty: 2 }], total: 14.50, status: "Picked Up" },
  { id: "#2831", date: "Feb 21, 9:15 AM", items: [{ name: "Pain au Chocolat", image: "🥐", qty: 3 }, { name: "Ciabatta Loaf", image: "🥖", qty: 1 }], total: 12.00, status: "Picked Up" },
  { id: "#2809", date: "Feb 18, 11:00 AM", items: [{ name: "Chocolate Layer Cake", image: "🎂", qty: 1 }], total: 44.50, status: "Picked Up" },
  { id: "#2794", date: "Feb 15, 8:45 AM", items: [{ name: "Raspberry Tart", image: "🫐", qty: 1 }, { name: "Sourdough Boule", image: "🍞", qty: 2 }], total: 15.50, status: "Picked Up" },
];

const savedAddresses = [
  { id: 1, label: "Baker Street", address: "123 Baker Street, Soho, London W1F 0TH", icon: "🏠", type: "Pickup" },
  { id: 2, label: "Office", address: "45 King's Road, Chelsea, London SW3 4ND", icon: "💼", type: "Delivery" },
  { id: 3, label: "Home", address: "78 Elm Park, Kensington, London W8 5QN", icon: "🏡", type: "Delivery" },
];
const noiseFilter = `url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E")`;

function PhoneFrame({ children }) {
  return (
    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "100vh", background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.cream})`, padding: "20px", fontFamily: "'DM Serif Display', Georgia, serif" }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300;1,9..40,400&display=swap" rel="stylesheet" />
      <div style={{
        width: 390, maxHeight: 844, height: "90vh", background: COLORS.warmWhite,
        borderRadius: 44, overflow: "hidden", position: "relative",
        boxShadow: `0 25px 80px rgba(74,55,40,0.15), 0 8px 30px rgba(74,55,40,0.1), inset 0 0 0 1px rgba(255,255,255,0.5)`,
        display: "flex", flexDirection: "column",
      }}>
        {/* Status Bar */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "12px 28px 4px", flexShrink: 0, background: COLORS.warmWhite, zIndex: 10 }}>
          <span style={{ fontSize: 14, fontWeight: 600, fontFamily: "'DM Sans', sans-serif", color: COLORS.darkBrown }}>9:41</span>
          <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
            <svg width="16" height="12" viewBox="0 0 16 12"><rect x="0" y="4" width="3" height="8" rx="1" fill={COLORS.darkBrown}/><rect x="4.5" y="2.5" width="3" height="9.5" rx="1" fill={COLORS.darkBrown}/><rect x="9" y="1" width="3" height="11" rx="1" fill={COLORS.darkBrown}/><rect x="13.5" y="0" width="2.5" height="12" rx="1" fill={COLORS.darkBrown} opacity="0.3"/></svg>
            <svg width="24" height="12" viewBox="0 0 24 12"><rect x="0" y="0" width="22" height="12" rx="3" stroke={COLORS.darkBrown} strokeWidth="1" fill="none"/><rect x="1.5" y="1.5" width="16" height="9" rx="2" fill={COLORS.darkBrown}/><rect x="23" y="3.5" width="1.5" height="5" rx="0.5" fill={COLORS.darkBrown}/></svg>
          </div>
        </div>
        {children}
      </div>
    </div>
  );
}

// --- SCREENS ---

function AddressSelector({ selectedAddress, onOpen, variant = "full" }) {
  const addr = savedAddresses.find(a => a.id === selectedAddress) || savedAddresses[0];

  return (
    <div onClick={onOpen} style={{
      display: "flex", alignItems: "center", gap: variant === "header" ? 8 : 10,
      padding: variant === "compact" ? "10px 14px" : variant === "header" ? "4px 0" : "10px 16px",
      background: variant === "compact" ? COLORS.white : "transparent",
      borderRadius: variant === "compact" ? 14 : 0,
      border: variant === "compact" ? `1px solid ${COLORS.beige}` : "none",
      cursor: "pointer",
      marginBottom: variant === "full" ? 14 : 0,
    }}>
      {variant !== "header" && <div style={{
        width: variant === "compact" ? 32 : 34, height: variant === "compact" ? 32 : 34,
        borderRadius: 10, background: COLORS.beige,
        display: "flex", alignItems: "center", justifyContent: "center",
        fontSize: variant === "compact" ? 14 : 15,
      }}>📍</div>}
      <div style={{ flex: variant === "header" ? "unset" : 1, minWidth: 0 }}>
        {variant === "header" && (
          <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: 0, letterSpacing: 0.3 }}>Deliver to ✦</p>
        )}
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          {variant === "header" && <span style={{ fontSize: 14 }}>📍</span>}
          <span style={{
            fontSize: variant === "header" ? 16 : variant === "compact" ? 13 : 14, color: COLORS.darkBrown,
            fontFamily: variant === "header" ? "'DM Serif Display', serif" : "'DM Sans', sans-serif",
            fontWeight: variant === "header" ? 400 : 500,
          }}>{variant === "header" ? addr.address.split(",")[0] : addr.label}</span>
          {variant !== "header" && <span style={{
            fontSize: 10, padding: "1px 6px", borderRadius: 5,
            background: addr.type === "Pickup" ? `${COLORS.sage}22` : `${COLORS.golden}30`,
            color: addr.type === "Pickup" ? COLORS.sage : COLORS.softBrown,
            fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
          }}>{addr.type}</span>}
        </div>
        {variant !== "header" && <p style={{
          fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif",
          margin: "2px 0 0", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
        }}>{addr.address}</p>}
      </div>
      <svg width={variant === "header" ? 12 : 14} height={variant === "header" ? 12 : 14} viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2.5" strokeLinecap="round"
        style={{ flexShrink: 0 }}>
        <polyline points="6 9 12 15 18 9"/>
      </svg>
    </div>
  );
}

function AddressBottomSheet({ open, selectedAddress, onSelect, onAddNew, onClose }) {
  if (!open) return null;
  return (
    <>
      <div onClick={onClose} style={{
        position: "absolute", inset: 0, background: "rgba(0,0,0,0.3)",
        zIndex: 60,
      }} />
      <div style={{
        position: "absolute", bottom: 0, left: 0, right: 0, zIndex: 61,
        background: COLORS.warmWhite, borderRadius: "24px 24px 0 0",
        padding: "8px 20px 32px",
        boxShadow: "0 -10px 40px rgba(0,0,0,0.12)",
      }}>
        <div style={{ width: 36, height: 4, borderRadius: 2, background: COLORS.beige, margin: "0 auto 16px" }} />
        <h3 style={{ fontSize: 18, color: COLORS.darkBrown, margin: "0 0 16px", fontWeight: 400 }}>Select Address</h3>

        {savedAddresses.map(a => (
          <div key={a.id} onClick={() => { onSelect(a.id); onClose(); }} style={{
            display: "flex", alignItems: "center", gap: 12, padding: "14px 14px",
            borderRadius: 16, cursor: "pointer", marginBottom: 6,
            background: a.id === selectedAddress ? COLORS.beige : "transparent",
            border: `1.5px solid ${a.id === selectedAddress ? COLORS.darkBrown : COLORS.beige}`,
            transition: "all 0.2s ease",
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: 12, fontSize: 18,
              background: a.id === selectedAddress ? `${COLORS.darkBrown}10` : COLORS.beige,
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{a.icon}</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <span style={{ fontSize: 15, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>{a.label}</span>
                <span style={{
                  fontSize: 10, padding: "2px 7px", borderRadius: 5,
                  background: a.type === "Pickup" ? `${COLORS.sage}22` : `${COLORS.golden}30`,
                  color: a.type === "Pickup" ? COLORS.sage : COLORS.softBrown,
                  fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                }}>{a.type}</span>
              </div>
              <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "3px 0 0" }}>{a.address}</p>
            </div>
            {a.id === selectedAddress && (
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.sage} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
            )}
          </div>
        ))}

        <div onClick={() => { onClose(); onAddNew && onAddNew(); }} style={{
          display: "flex", alignItems: "center", justifyContent: "center", gap: 10,
          padding: 14, borderRadius: 16, cursor: "pointer", marginTop: 6,
          border: `2px dashed ${COLORS.beige}`, color: COLORS.softBrown,
          fontSize: 14, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
        }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add new address
        </div>
      </div>
    </>
  );
}

function HomeScreen({ onProductClick, onOrdersClick, onQuickAdd, onNavigate, cartCount, selectedAddress, onAddressOpen, favourites, onToggleFavourite }) {
  const [activeCategory, setActiveCategory] = useState("all");
  const [searchFocused, setSearchFocused] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [viewMode, setViewMode] = useState("list");
  const [loaded, setLoaded] = useState(false);
  const [toast, setToast] = useState(null);
  const [sortBy, setSortBy] = useState("default");
  const [showSortMenu, setShowSortMenu] = useState(false);
  const [showFilterPanel, setShowFilterPanel] = useState(false);
  const [activeFilters, setActiveFilters] = useState([]);
  useEffect(() => { setTimeout(() => setLoaded(true), 100); }, []);

  const handleQuickAdd = (product) => {
    onQuickAdd(product);
    setToast(product.name);
    setTimeout(() => setToast(null), 1800);
  };

  const toggleFilter = (f) => setActiveFilters(prev => prev.includes(f) ? prev.filter(x => x !== f) : [...prev, f]);

  const filterOptions = ["Organic", "Vegan", "Gluten-Free Option", "Contains Nuts", "Contains Dairy"];

  const sortOptions = [
    { value: "default", label: "Default" },
    { value: "price_low", label: "Price: Low → High" },
    { value: "price_high", label: "Price: High → Low" },
    { value: "rating", label: "Top Rated" },
    { value: "popular", label: "Most Popular" },
  ];

  let filtered = activeCategory === "all" ? [...products] : products.filter(p => p.category === activeCategory);

  // Search filter
  if (searchQuery.trim()) {
    const q = searchQuery.toLowerCase();
    filtered = filtered.filter(p =>
      p.name.toLowerCase().includes(q) ||
      p.description.toLowerCase().includes(q) ||
      p.category.toLowerCase().includes(q) ||
      p.tags.some(t => t.toLowerCase().includes(q))
    );
  }

  // Dietary filters
  if (activeFilters.length > 0) {
    filtered = filtered.filter(p => activeFilters.every(f => p.tags.includes(f)));
  }

  // Sort
  if (sortBy === "price_low") filtered.sort((a, b) => a.price - b.price);
  else if (sortBy === "price_high") filtered.sort((a, b) => b.price - a.price);
  else if (sortBy === "rating") filtered.sort((a, b) => b.rating - a.rating);
  else if (sortBy === "popular") filtered.sort((a, b) => b.reviews - a.reviews);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Header */}
      <div style={{
        padding: "8px 24px 0", flexShrink: 0,
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(-10px)",
        transition: "all 0.6s cubic-bezier(0.22,1,0.36,1)",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <AddressSelector selectedAddress={selectedAddress} onOpen={onAddressOpen} variant="header" />
          </div>
          <div style={{ position: "relative", cursor: "pointer", flexShrink: 0 }} onClick={() => onNavigate("profile")}>
            <div style={{ width: 44, height: 44, borderRadius: 22, background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center" }}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
            </div>
            <div style={{ position: "absolute", top: -1, right: -1, width: 18, height: 18, borderRadius: 9, background: COLORS.terracotta, color: "#fff", fontSize: 10, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'DM Sans', sans-serif", fontWeight: 600 }}>3</div>
          </div>
        </div>

        {/* Search + Filter */}
        <div style={{ display: "flex", gap: 10, marginBottom: showFilterPanel ? 12 : 20, transition: "margin 0.3s ease" }}>
          <div style={{
            display: "flex", alignItems: "center", gap: 10, padding: "12px 16px", flex: 1,
            background: searchFocused ? COLORS.white : COLORS.beige,
            borderRadius: 16, border: `1.5px solid ${searchFocused ? COLORS.golden : "transparent"}`,
            transition: "all 0.3s ease",
            boxShadow: searchFocused ? `0 4px 20px ${COLORS.shadow}` : "none",
          }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2" strokeLinecap="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input
              placeholder="Search breads, pastries..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              onFocus={() => setSearchFocused(true)}
              onBlur={() => setSearchFocused(false)}
              style={{ border: "none", outline: "none", background: "transparent", flex: 1, fontSize: 14, color: COLORS.text, fontFamily: "'DM Sans', sans-serif", letterSpacing: 0.2 }}
            />
            {searchQuery && (
              <div onClick={() => setSearchQuery("")} style={{ cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", width: 20, height: 20, borderRadius: 10, background: COLORS.softBrown + "22" }}>
                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2.5" strokeLinecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </div>
            )}
          </div>
          <button onClick={() => setShowFilterPanel(!showFilterPanel)} style={{
            width: 48, height: 48, borderRadius: 16, border: "none", cursor: "pointer", flexShrink: 0,
            background: showFilterPanel || activeFilters.length > 0 ? COLORS.darkBrown : COLORS.beige,
            display: "flex", alignItems: "center", justifyContent: "center", position: "relative",
            transition: "all 0.3s ease",
            boxShadow: showFilterPanel ? "0 4px 15px rgba(74,55,40,0.2)" : "none",
          }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={showFilterPanel || activeFilters.length > 0 ? COLORS.cream : COLORS.softBrown} strokeWidth="2" strokeLinecap="round">
              <line x1="4" y1="6" x2="20" y2="6"/><line x1="7" y1="12" x2="17" y2="12"/><line x1="10" y1="18" x2="14" y2="18"/>
            </svg>
            {activeFilters.length > 0 && (
              <div style={{ position: "absolute", top: -2, right: -2, width: 18, height: 18, borderRadius: 9, background: COLORS.terracotta, color: "#fff", fontSize: 10, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'DM Sans', sans-serif", fontWeight: 600 }}>{activeFilters.length}</div>
            )}
          </button>
        </div>

        {/* Filter Panel */}
        <div style={{
          overflow: "hidden",
          maxHeight: showFilterPanel ? 120 : 0,
          opacity: showFilterPanel ? 1 : 0,
          transition: "all 0.35s cubic-bezier(0.22,1,0.36,1)",
          marginBottom: showFilterPanel ? 16 : 0,
        }}>
          <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 8px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Dietary Filters</p>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
            {filterOptions.map(f => {
              const active = activeFilters.includes(f);
              const label = f.replace(" Option", "");
              return (
                <button key={f} onClick={() => toggleFilter(f)} style={{
                  padding: "7px 14px", borderRadius: 10, cursor: "pointer",
                  background: active ? COLORS.darkBrown : COLORS.white,
                  color: active ? COLORS.cream : COLORS.softBrown,
                  border: `1.5px solid ${active ? COLORS.darkBrown : COLORS.beige}`,
                  fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                  transition: "all 0.25s ease", whiteSpace: "nowrap",
                }}>
                  {active && "✓ "}{label}
                </button>
              );
            })}
          </div>
          {activeFilters.length > 0 && (
            <button onClick={() => setActiveFilters([])} style={{
              marginTop: 8, padding: 0, border: "none", background: "none", cursor: "pointer",
              fontSize: 12, fontFamily: "'DM Sans', sans-serif", color: COLORS.terracotta, fontWeight: 500,
            }}>Clear all filters</button>
          )}
        </div>
      </div>

      {/* Categories */}
      <div style={{
        display: "flex", gap: 10, padding: "0 24px 16px", flexShrink: 0, overflowX: "auto",
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(10px)",
        transition: "all 0.6s cubic-bezier(0.22,1,0.36,1) 0.15s",
      }}>
        <CategoryPill label="All" icon="✦" active={activeCategory === "all"} onClick={() => setActiveCategory("all")} />
        {categories.map(c => (
          <CategoryPill key={c.id} label={c.label} icon={c.icon} active={activeCategory === c.id} onClick={() => setActiveCategory(c.id)} />
        ))}
      </div>

      {/* Scrollable Content */}
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 100px" }}>
        {/* Recent Orders — only in default browse mode */}
        {!searchQuery && activeCategory === "all" && activeFilters.length === 0 && (
        <div style={{
          marginBottom: 20,
          opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(10px)",
          transition: "all 0.6s cubic-bezier(0.22,1,0.36,1) 0.25s",
        }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 12 }}>
            <h2 style={{ fontSize: 17, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Recent Orders</h2>
            <span onClick={onOrdersClick} style={{ fontSize: 13, color: COLORS.caramel, fontFamily: "'DM Sans', sans-serif", cursor: "pointer", fontWeight: 500 }}>View all →</span>
          </div>
          <div style={{ display: "flex", gap: 12, overflowX: "auto", paddingBottom: 4, marginLeft: -24, marginRight: -24, paddingLeft: 24, paddingRight: 24 }}>
            {recentOrders.slice(0, 3).map((order, i) => (
              <div key={order.id} onClick={onOrdersClick} style={{
                minWidth: 200, padding: "14px 16px", borderRadius: 18, cursor: "pointer",
                background: i === 0 ? `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})` : `linear-gradient(160deg, #FFFAF3, ${COLORS.beige}40)`,
                border: i === 0 ? "none" : `1px solid ${COLORS.beige}`,
                boxShadow: i === 0 ? "0 4px 15px rgba(74,55,40,0.2)" : "0 3px 14px rgba(74,55,40,0.08), 0 1px 3px rgba(74,55,40,0.05)",
                flexShrink: 0,
              }}>
                <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 10 }}>
                  <span style={{ fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 600, color: i === 0 ? COLORS.golden : COLORS.softBrown }}>{order.id}</span>
                  <span style={{ fontSize: 10, fontFamily: "'DM Sans', sans-serif", color: i === 0 ? "rgba(255,255,255,0.5)" : COLORS.textLight }}>· {order.date.split(",")[0]}</span>
                </div>
                <div style={{ display: "flex", flexDirection: "column", gap: 3, marginBottom: 10 }}>
                  {order.items.map((item, j) => (
                    <span key={j} style={{
                      fontSize: 13, fontFamily: "'DM Sans', sans-serif",
                      color: i === 0 ? "rgba(255,255,255,0.8)" : COLORS.textLight,
                    }}>{item.name} × {item.qty}</span>
                  ))}
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                  <span style={{ fontSize: 15, fontWeight: 400, color: i === 0 ? COLORS.cream : COLORS.darkBrown }}>${order.total.toFixed(2)}</span>
                  <span style={{
                    fontSize: 10, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                    padding: "3px 8px", borderRadius: 6,
                    background: i === 0 ? "rgba(255,255,255,0.12)" : `${COLORS.sage}22`,
                    color: i === 0 ? COLORS.golden : COLORS.sage,
                  }}>{order.status}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
        )}

        {/* Section Title + Sort + View Toggle */}
        <div style={{
          display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14,
          opacity: loaded ? 1 : 0, transition: "opacity 0.6s ease 0.3s",
        }}>
          <h2 style={{ fontSize: 20, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Fresh Today</h2>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            {/* Sort By */}
            <div style={{ position: "relative" }}>
              <button onClick={() => setShowSortMenu(!showSortMenu)} style={{
                display: "flex", alignItems: "center", gap: 5, padding: "7px 12px",
                borderRadius: 10, border: "none", cursor: "pointer",
                background: sortBy !== "default" ? COLORS.darkBrown : COLORS.beige,
                color: sortBy !== "default" ? COLORS.cream : COLORS.softBrown,
                fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                transition: "all 0.3s ease", whiteSpace: "nowrap",
              }}>
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke={sortBy !== "default" ? COLORS.cream : COLORS.softBrown} strokeWidth="2" strokeLinecap="round">
                  <path d="M3 6h18M6 12h12M9 18h6"/>
                </svg>
                {sortBy === "default" ? "Sort" : sortOptions.find(s => s.value === sortBy)?.label}
              </button>
              {showSortMenu && (
                <>
                  <div onClick={() => setShowSortMenu(false)} style={{ position: "fixed", inset: 0, zIndex: 29 }} />
                  <div style={{
                    position: "absolute", top: 40, right: 0, zIndex: 30,
                    background: COLORS.white, borderRadius: 16, padding: 6,
                    boxShadow: "0 8px 30px rgba(74,55,40,0.15), 0 2px 8px rgba(74,55,40,0.08)",
                    border: `1px solid ${COLORS.beige}`, minWidth: 180,
                  }}>
                    {sortOptions.map(opt => (
                      <button key={opt.value} onClick={() => { setSortBy(opt.value); setShowSortMenu(false); }} style={{
                        display: "flex", alignItems: "center", justifyContent: "space-between", width: "100%", padding: "10px 14px",
                        borderRadius: 10, border: "none", cursor: "pointer",
                        background: sortBy === opt.value ? COLORS.beige : "transparent",
                        color: sortBy === opt.value ? COLORS.darkBrown : COLORS.softBrown,
                        fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: sortBy === opt.value ? 600 : 400,
                        transition: "background 0.2s ease", textAlign: "left",
                      }}>
                        {opt.label}
                        {sortBy === opt.value && (
                          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                        )}
                      </button>
                    ))}
                  </div>
                </>
              )}
            </div>
            <button onClick={() => setViewMode("list")} style={{
              width: 34, height: 34, borderRadius: 10, border: "none", cursor: "pointer",
              background: viewMode === "list" ? COLORS.darkBrown : COLORS.beige,
              display: "flex", alignItems: "center", justifyContent: "center",
              transition: "all 0.3s ease",
            }}>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <rect x="0" y="1" width="16" height="3" rx="1" fill={viewMode === "list" ? COLORS.cream : COLORS.softBrown}/>
                <rect x="0" y="6.5" width="16" height="3" rx="1" fill={viewMode === "list" ? COLORS.cream : COLORS.softBrown}/>
                <rect x="0" y="12" width="16" height="3" rx="1" fill={viewMode === "list" ? COLORS.cream : COLORS.softBrown}/>
              </svg>
            </button>
            <button onClick={() => setViewMode("grid")} style={{
              width: 34, height: 34, borderRadius: 10, border: "none", cursor: "pointer",
              background: viewMode === "grid" ? COLORS.darkBrown : COLORS.beige,
              display: "flex", alignItems: "center", justifyContent: "center",
              transition: "all 0.3s ease",
            }}>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <rect x="0" y="0" width="7" height="7" rx="1.5" fill={viewMode === "grid" ? COLORS.cream : COLORS.softBrown}/>
                <rect x="9" y="0" width="7" height="7" rx="1.5" fill={viewMode === "grid" ? COLORS.cream : COLORS.softBrown}/>
                <rect x="0" y="9" width="7" height="7" rx="1.5" fill={viewMode === "grid" ? COLORS.cream : COLORS.softBrown}/>
                <rect x="9" y="9" width="7" height="7" rx="1.5" fill={viewMode === "grid" ? COLORS.cream : COLORS.softBrown}/>
              </svg>
            </button>
          </div>
        </div>

        {/* Active filters / results count */}
        {(searchQuery || activeFilters.length > 0 || sortBy !== "default") && (
          <div style={{ display: "flex", alignItems: "center", gap: 6, marginBottom: 12, flexWrap: "wrap" }}>
            <span style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>
              {filtered.length} result{filtered.length !== 1 ? "s" : ""}
            </span>
            {searchQuery && (
              <span style={{ fontSize: 11, padding: "3px 10px", borderRadius: 8, background: `${COLORS.golden}18`, color: COLORS.softBrown, fontFamily: "'DM Sans', sans-serif" }}>
                "{searchQuery}"
              </span>
            )}
            {activeFilters.map(f => (
              <span key={f} onClick={() => toggleFilter(f)} style={{
                fontSize: 11, padding: "3px 10px", borderRadius: 8, cursor: "pointer",
                background: `${COLORS.terracotta}15`, color: COLORS.terracotta,
                fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
              }}>{f.replace(" Option", "")} ×</span>
            ))}
          </div>
        )}

        {/* Empty State */}
        {filtered.length === 0 ? (
          <div style={{ textAlign: "center", padding: "48px 20px" }}>
            <div style={{ fontSize: 48, marginBottom: 14 }}>🔍</div>
            <p style={{ fontSize: 17, color: COLORS.darkBrown, margin: "0 0 6px" }}>No items found</p>
            <p style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 16px", lineHeight: 1.5 }}>
              Try adjusting your search or filters
            </p>
            <button onClick={() => { setSearchQuery(""); setActiveFilters([]); setSortBy("default"); setActiveCategory("all"); }} style={{
              padding: "10px 24px", borderRadius: 12, border: `1.5px solid ${COLORS.darkBrown}`,
              background: "transparent", cursor: "pointer",
              fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
              color: COLORS.darkBrown,
            }}>Clear all</button>
          </div>
        ) : (
          <>
            {/* Product Cards - List View */}
            {viewMode === "list" && (
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                {filtered.map((product, i) => (
                  <ProductCard key={product.id} product={product} index={i} loaded={loaded} onClick={() => onProductClick(product)} onQuickAdd={() => handleQuickAdd(product)} isFav={favourites.includes(product.id)} onToggleFav={() => onToggleFavourite(product.id)} />
                ))}
              </div>
            )}

            {/* Product Cards - Grid View */}
            {viewMode === "grid" && (
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
                {filtered.map((product, i) => (
                  <GridProductCard key={product.id} product={product} index={i} loaded={loaded} onClick={() => onProductClick(product)} onQuickAdd={() => handleQuickAdd(product)} isFav={favourites.includes(product.id)} onToggleFav={() => onToggleFavourite(product.id)} />
                ))}
              </div>
            )}
          </>
        )}
      </div>

      {/* Toast Notification */}
      <div style={{
        position: "absolute", bottom: 80, left: 24, right: 24, zIndex: 20,
        opacity: toast ? 1 : 0, transform: toast ? "translateY(0)" : "translateY(12px)",
        transition: "all 0.35s cubic-bezier(0.22,1,0.36,1)",
        pointerEvents: "none",
      }}>
        <div style={{
          display: "flex", alignItems: "center", gap: 10, padding: "14px 18px",
          background: COLORS.darkBrown, borderRadius: 16,
          boxShadow: "0 8px 30px rgba(74,55,40,0.3)",
        }}>
          <div style={{
            width: 24, height: 24, borderRadius: 12, background: COLORS.sage,
            display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
          }}>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={COLORS.white} strokeWidth="3"><polyline points="20 6 9 17 4 12"/></svg>
          </div>
          <span style={{ fontSize: 14, color: COLORS.cream, fontFamily: "'DM Sans', sans-serif", fontWeight: 400 }}>{toast} added to cart</span>
        </div>
      </div>

      {/* Bottom Nav */}
      <BottomNav active="home" onNavigate={onNavigate} cartCount={cartCount} />
    </div>
  );
}

function CategoryPill({ label, icon, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      display: "flex", alignItems: "center", gap: 6, padding: "10px 18px",
      borderRadius: 50, border: "none", cursor: "pointer", whiteSpace: "nowrap",
      background: active ? COLORS.darkBrown : COLORS.white,
      color: active ? COLORS.cream : COLORS.softBrown,
      fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
      boxShadow: active ? `0 4px 15px rgba(74,55,40,0.2)` : `0 1px 4px ${COLORS.shadow}`,
      transition: "all 0.3s ease", letterSpacing: 0.3,
    }}>
      <span style={{ fontSize: 15 }}>{icon}</span> {label}
    </button>
  );
}

function ProductCard({ product, index, loaded, onClick, onQuickAdd, isFav, onToggleFav }) {
  const [hovered, setHovered] = useState(false);
  const [added, setAdded] = useState(false);

  const handleAdd = (e) => {
    e.stopPropagation();
    if (added) return;
    setAdded(true);
    onQuickAdd();
    setTimeout(() => setAdded(false), 1200);
  };

  const handleFav = (e) => {
    e.stopPropagation();
    onToggleFav();
  };

  return (
    <div
      onClick={onClick}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        display: "flex", gap: 16, padding: 14, borderRadius: 20,
        background: COLORS.white, cursor: "pointer",
        boxShadow: hovered ? `0 8px 30px rgba(74,55,40,0.12)` : `0 2px 10px ${COLORS.shadow}`,
        transform: hovered ? "translateY(-2px)" : "translateY(0)",
        opacity: loaded ? 1 : 0,
        transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${0.35 + index * 0.08}s`,
        border: `1px solid ${COLORS.beige}`,
      }}
    >
      {/* Image placeholder */}
      <div style={{
        width: 90, height: 90, borderRadius: 16, flexShrink: 0,
        background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
        display: "flex", alignItems: "center", justifyContent: "center",
        fontSize: 40, position: "relative", overflow: "hidden",
      }}>
        {product.image}
        {product.badge && (
          <div style={{
            position: "absolute", top: 6, left: 6, padding: "2px 8px",
            borderRadius: 8, fontSize: 9, fontFamily: "'DM Sans', sans-serif",
            fontWeight: 600, letterSpacing: 0.5, textTransform: "uppercase",
            background: product.badge === "New" ? COLORS.sage : product.badge === "Bestseller" ? COLORS.terracotta : COLORS.golden,
            color: COLORS.white,
          }}>{product.badge}</div>
        )}
      </div>
      <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", minWidth: 0 }}>
        <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between" }}>
          <h3 style={{ fontSize: 16, color: COLORS.darkBrown, margin: 0, fontWeight: 400, letterSpacing: -0.2 }}>{product.name}</h3>
          <div onClick={handleFav} style={{ cursor: "pointer", padding: 2, flexShrink: 0, marginLeft: 6, transition: "transform 0.2s ease", transform: isFav ? "scale(1.15)" : "scale(1)" }}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill={isFav ? COLORS.terracotta : "none"} stroke={isFav ? COLORS.terracotta : COLORS.beige} strokeWidth="2" strokeLinecap="round">
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
          </div>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 4, margin: "4px 0" }}>
          <span style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>{product.time}</span>
        </div>
        <div style={{ display: "flex", alignItems: "center", marginTop: 2 }}>
          <span style={{ fontSize: 18, color: COLORS.darkBrown, fontWeight: 400 }}>${product.price.toFixed(2)}</span>
          <div onClick={handleAdd} style={{
            width: 32, height: 32, borderRadius: 12, marginLeft: "auto",
            background: added ? COLORS.sage : COLORS.darkBrown,
            display: "flex", alignItems: "center", justifyContent: "center",
            color: COLORS.cream, fontSize: 18, fontWeight: 300, lineHeight: 1,
            boxShadow: "0 2px 8px rgba(74,55,40,0.2)",
            transition: "all 0.3s cubic-bezier(0.22,1,0.36,1)",
            transform: added ? "scale(1.15)" : "scale(1)",
          }}>
            {added ? (
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={COLORS.white} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
            ) : "+"}
          </div>
        </div>
      </div>
    </div>
  );
}

function GridProductCard({ product, index, loaded, onClick, onQuickAdd, isFav, onToggleFav }) {
  const [hovered, setHovered] = useState(false);
  const [added, setAdded] = useState(false);

  const handleAdd = (e) => {
    e.stopPropagation();
    if (added) return;
    setAdded(true);
    onQuickAdd();
    setTimeout(() => setAdded(false), 1200);
  };

  const handleFav = (e) => {
    e.stopPropagation();
    onToggleFav();
  };

  return (
    <div
      onClick={onClick}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        display: "flex", flexDirection: "column", borderRadius: 20,
        background: COLORS.white, cursor: "pointer", overflow: "hidden",
        boxShadow: hovered ? `0 8px 30px rgba(74,55,40,0.12)` : `0 2px 10px ${COLORS.shadow}`,
        transform: hovered ? "translateY(-3px) scale(1.02)" : "translateY(0) scale(1)",
        opacity: loaded ? 1 : 0,
        transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${0.35 + index * 0.06}s`,
        border: `1px solid ${COLORS.beige}`,
      }}
    >
      {/* Image */}
      <div style={{
        width: "100%", height: 120, position: "relative",
        background: `linear-gradient(155deg, ${COLORS.beige}, ${COLORS.lightGold})`,
        display: "flex", alignItems: "center", justifyContent: "center",
        fontSize: 50,
      }}>
        {product.image}
        {product.badge && (
          <div style={{
            position: "absolute", top: 8, left: 8, padding: "3px 8px",
            borderRadius: 8, fontSize: 9, fontFamily: "'DM Sans', sans-serif",
            fontWeight: 600, letterSpacing: 0.5, textTransform: "uppercase",
            background: product.badge === "New" ? COLORS.sage : product.badge === "Bestseller" ? COLORS.terracotta : COLORS.golden,
            color: COLORS.white,
          }}>{product.badge}</div>
        )}
        {/* Heart icon on image */}
        <div onClick={handleFav} style={{
          position: "absolute", top: 8, right: 8,
          width: 28, height: 28, borderRadius: 9,
          background: "rgba(255,255,255,0.85)", backdropFilter: "blur(6px)",
          display: "flex", alignItems: "center", justifyContent: "center",
          cursor: "pointer", transition: "transform 0.2s ease",
          transform: isFav ? "scale(1.1)" : "scale(1)",
        }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill={isFav ? COLORS.terracotta : "none"} stroke={isFav ? COLORS.terracotta : COLORS.softBrown} strokeWidth="2" strokeLinecap="round">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
        </div>
      </div>
      {/* Info */}
      <div style={{ padding: "14px 12px 12px" }}>
        <h3 style={{
          fontSize: 14, color: COLORS.darkBrown, margin: 0, fontWeight: 400,
          letterSpacing: -0.2, lineHeight: 1.3,
          overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
        }}>{product.name}</h3>
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "5px 0 8px" }}>{product.time}</p>
        <div style={{ display: "flex", alignItems: "center" }}>
          <span style={{ fontSize: 17, color: COLORS.darkBrown, fontWeight: 400 }}>${product.price.toFixed(2)}</span>
          <div onClick={handleAdd} style={{
            width: 28, height: 28, borderRadius: 10, marginLeft: "auto",
            background: added ? COLORS.sage : COLORS.darkBrown,
            display: "flex", alignItems: "center", justifyContent: "center",
            color: COLORS.cream, fontSize: 16, fontWeight: 300, lineHeight: 1,
            boxShadow: "0 2px 8px rgba(74,55,40,0.2)",
            transition: "all 0.3s cubic-bezier(0.22,1,0.36,1)",
            transform: added ? "scale(1.15)" : "scale(1)",
          }}>
            {added ? (
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={COLORS.white} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
            ) : "+"}
          </div>
        </div>
      </div>
    </div>
  );
}

function ProductDetailScreen({ product, onBack, onAddToCart, onProductClick, isFav, onToggleFav }) {
  const [quantity, setQuantity] = useState(1);
  const [sweetness, setSweetness] = useState(2);
  const [selectedTags, setSelectedTags] = useState([]);
  const [loaded, setLoaded] = useState(false);
  const [activeImage, setActiveImage] = useState(0);
  const [showAllReviews, setShowAllReviews] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const sweetnessLabels = ["None", "Light", "Regular", "Extra"];

  // Context-aware options based on category
  const categoryOptions = {
    breads: { label: "Slice Preference", options: ["Unsliced", "Thick Cut", "Thin Cut", "Half Loaf"] },
    pastries: { label: "Warm it Up?", options: ["Room Temp", "Lightly Warmed", "Toasty"] },
    cakes: { label: "Cake Size", options: ["6 inch", "8 inch", "10 inch", "12 inch"] },
    cookies: { label: "Pack Size", options: ["Single", "Half Dozen", "Dozen", "Baker's Dozen"] },
  };
  const contextOpt = categoryOptions[product.category];
  const [contextChoice, setContextChoice] = useState(0);

  // Gallery images (simulated views of product)
  const galleryDots = [product.image, "📸", "🎨"];

  // Sample reviews
  const reviews = [
    { name: "Sarah M.", rating: 5, date: "2 days ago", text: "Absolutely incredible! The crust is perfectly crispy and the inside is so soft. Will definitely order again.", avatar: "S" },
    { name: "James K.", rating: 5, date: "1 week ago", text: "Best in the city, hands down. You can taste the quality in every bite.", avatar: "J" },
    { name: "Amara T.", rating: 4, date: "2 weeks ago", text: "Really lovely. Slight wait for pickup but worth it for the freshness.", avatar: "A" },
  ];

  // Related products (same category, excluding current)
  const related = products.filter(p => p.category === product.category && p.id !== product.id)
    .concat(products.filter(p => p.category !== product.category)).slice(0, 4);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Hero Image with Gallery */}
      <div style={{
        height: 280, flexShrink: 0, position: "relative",
        background: `linear-gradient(170deg, ${COLORS.beige} 0%, ${COLORS.lightGold} 50%, ${COLORS.golden} 100%)`,
        display: "flex", alignItems: "center", justifyContent: "center",
        fontSize: 110,
        opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease",
      }}>
        {product.image}
        {/* Back button */}
        <button onClick={onBack} style={{
          position: "absolute", top: 12, left: 20, width: 40, height: 40, borderRadius: 14,
          background: "rgba(255,255,255,0.85)", backdropFilter: "blur(10px)",
          border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
          boxShadow: "0 2px 10px rgba(0,0,0,0.08)",
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        {/* Action buttons */}
        <div style={{ position: "absolute", top: 12, right: 20, display: "flex", gap: 8 }}>
          <button onClick={() => {}} style={{
            width: 40, height: 40, borderRadius: 14,
            background: "rgba(255,255,255,0.85)", backdropFilter: "blur(10px)",
            border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
            boxShadow: "0 2px 10px rgba(0,0,0,0.08)",
          }}>
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2" strokeLinecap="round"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
          </button>
          <button onClick={() => onToggleFav()} style={{
            width: 40, height: 40, borderRadius: 14,
            background: "rgba(255,255,255,0.85)", backdropFilter: "blur(10px)",
            border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
            boxShadow: "0 2px 10px rgba(0,0,0,0.08)",
            transition: "transform 0.2s ease",
            transform: isFav ? "scale(1.1)" : "scale(1)",
          }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill={isFav ? COLORS.terracotta : "none"} stroke={COLORS.terracotta} strokeWidth="2" strokeLinecap="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
          </button>
        </div>
        {product.badge && (
          <div style={{
            position: "absolute", bottom: 40, left: 20, padding: "6px 14px", borderRadius: 12,
            background: "rgba(255,255,255,0.9)", backdropFilter: "blur(8px)",
            fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 600,
            color: COLORS.darkBrown, letterSpacing: 0.5,
          }}>✦ {product.badge}</div>
        )}
        {/* Gallery dots */}
        <div style={{ position: "absolute", bottom: 14, display: "flex", gap: 6 }}>
          {galleryDots.map((_, i) => (
            <div key={i} onClick={() => setActiveImage(i)} style={{
              width: activeImage === i ? 20 : 7, height: 7, borderRadius: 4,
              background: activeImage === i ? COLORS.white : "rgba(255,255,255,0.45)",
              cursor: "pointer", transition: "all 0.3s ease",
            }} />
          ))}
        </div>
      </div>

      {/* Content */}
      <div style={{
        flex: 1, overflowY: "auto", padding: "24px 24px 120px",
        background: COLORS.warmWhite,
        borderRadius: "28px 28px 0 0", marginTop: -24, position: "relative", zIndex: 2,
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(20px)",
        transition: "all 0.6s cubic-bezier(0.22,1,0.36,1) 0.2s",
      }}>
        {/* Title & Price */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 6 }}>
          <div style={{ flex: 1 }}>
            <h1 style={{ fontSize: 26, color: COLORS.darkBrown, margin: 0, fontWeight: 400, letterSpacing: -0.5 }}>{product.name}</h1>
            <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 6 }}>
              <span style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>{product.time}</span>
            </div>
          </div>
          <span style={{ fontSize: 28, color: COLORS.darkBrown, fontWeight: 400 }}>${product.price.toFixed(2)}</span>
        </div>

        <p style={{ fontSize: 14, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", lineHeight: 1.6, margin: "12px 0 16px" }}>{product.description}</p>

        {/* Tags */}
        <div style={{ display: "flex", gap: 8, flexWrap: "wrap", marginBottom: 22 }}>
          {product.tags.map(tag => (
            <span key={tag} style={{
              padding: "5px 12px", borderRadius: 10, fontSize: 12,
              fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
              background: tag.includes("Gluten") ? `${COLORS.sage}22` : tag.includes("Vegan") ? `${COLORS.sage}22` : `${COLORS.roseDust}22`,
              color: tag.includes("Gluten") || tag.includes("Vegan") ? COLORS.sage : COLORS.roseDust,
            }}>{tag}</span>
          ))}
        </div>

        {/* Context-Aware Option */}
        {contextOpt && (
          <div style={{ marginBottom: 22 }}>
            <h3 style={{ fontSize: 15, color: COLORS.darkBrown, margin: "0 0 10px", fontWeight: 400 }}>{contextOpt.label}</h3>
            <div style={{ display: "flex", gap: 8 }}>
              {contextOpt.options.map((opt, i) => (
                <button key={i} onClick={() => setContextChoice(i)} style={{
                  flex: 1, padding: "10px 4px", borderRadius: 12, border: "none", cursor: "pointer",
                  background: contextChoice === i ? COLORS.darkBrown : COLORS.beige,
                  color: contextChoice === i ? COLORS.cream : COLORS.softBrown,
                  fontSize: 11, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                  transition: "all 0.25s ease",
                  boxShadow: contextChoice === i ? "0 4px 12px rgba(74,55,40,0.2)" : "none",
                }}>{opt}</button>
              ))}
            </div>
          </div>
        )}

        {/* Sweetness - only for pastries/cakes/cookies */}
        {product.category !== "breads" && (
          <div style={{ marginBottom: 22 }}>
            <h3 style={{ fontSize: 15, color: COLORS.darkBrown, margin: "0 0 10px", fontWeight: 400 }}>Sweetness Level</h3>
            <div style={{ display: "flex", gap: 8 }}>
              {sweetnessLabels.map((label, i) => (
                <button key={i} onClick={() => setSweetness(i)} style={{
                  flex: 1, padding: "10px 0", borderRadius: 12, border: "none", cursor: "pointer",
                  background: sweetness === i ? COLORS.darkBrown : COLORS.beige,
                  color: sweetness === i ? COLORS.cream : COLORS.softBrown,
                  fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                  transition: "all 0.25s ease",
                  boxShadow: sweetness === i ? "0 4px 12px rgba(74,55,40,0.2)" : "none",
                }}>{label}</button>
              ))}
            </div>
          </div>
        )}

        {/* Quantity */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 28, padding: "14px 20px", background: COLORS.beige, borderRadius: 16 }}>
          <span style={{ fontSize: 15, color: COLORS.darkBrown, fontWeight: 400 }}>Quantity</span>
          <div style={{ display: "flex", alignItems: "center", gap: 16 }}>
            <button onClick={() => setQuantity(Math.max(1, quantity - 1))} style={{
              width: 36, height: 36, borderRadius: 12, border: `1.5px solid ${COLORS.golden}`, background: "transparent",
              color: COLORS.darkBrown, fontSize: 18, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
            }}>−</button>
            <span style={{ fontSize: 18, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 600, minWidth: 24, textAlign: "center" }}>{quantity}</span>
            <button onClick={() => setQuantity(quantity + 1)} style={{
              width: 36, height: 36, borderRadius: 12, border: "none", background: COLORS.darkBrown,
              color: COLORS.cream, fontSize: 18, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
            }}>+</button>
          </div>
        </div>

        {/* Reviews Section */}
        <div style={{ marginBottom: 28 }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", marginBottom: 14 }}>
            <h3 style={{ fontSize: 17, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Reviews</h3>
            <span onClick={() => setShowAllReviews(!showAllReviews)} style={{ fontSize: 13, color: COLORS.caramel, fontFamily: "'DM Sans', sans-serif", cursor: "pointer", fontWeight: 500 }}>
              {showAllReviews ? "Show less" : `See all ${product.reviews}`} →
            </span>
          </div>
          {/* Rating summary bar */}
          <div style={{
            display: "flex", alignItems: "center", gap: 14, padding: "14px 18px",
            background: COLORS.white, borderRadius: 16, border: `1px solid ${COLORS.beige}`, marginBottom: 12,
          }}>
            <div style={{ textAlign: "center" }}>
              <span style={{ fontSize: 32, color: COLORS.darkBrown, fontWeight: 400 }}>{product.rating}</span>
              <div style={{ display: "flex", gap: 2, marginTop: 2 }}>
                {[1,2,3,4,5].map(s => (
                  <span key={s} style={{ fontSize: 11, color: s <= Math.round(product.rating) ? COLORS.accent : COLORS.beige }}>★</span>
                ))}
              </div>
            </div>
            <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 4 }}>
              {[5,4,3,2,1].map(s => {
                const pct = s === 5 ? 78 : s === 4 ? 16 : s === 3 ? 4 : s === 2 ? 2 : 0;
                return (
                  <div key={s} style={{ display: "flex", alignItems: "center", gap: 6 }}>
                    <span style={{ fontSize: 10, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", width: 8 }}>{s}</span>
                    <div style={{ flex: 1, height: 4, borderRadius: 2, background: COLORS.beige }}>
                      <div style={{ width: `${pct}%`, height: "100%", borderRadius: 2, background: COLORS.golden, transition: "width 0.5s ease" }} />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
          {/* Individual reviews */}
          {reviews.slice(0, showAllReviews ? 3 : 2).map((review, i) => (
            <div key={i} style={{
              padding: "14px 16px", background: COLORS.white, borderRadius: 16,
              border: `1px solid ${COLORS.beige}`, marginBottom: 8,
            }}>
              <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 8 }}>
                <div style={{
                  width: 32, height: 32, borderRadius: 10,
                  background: `linear-gradient(135deg, ${COLORS.golden}, ${COLORS.caramel})`,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  color: COLORS.white, fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: 600,
                }}>{review.avatar}</div>
                <div style={{ flex: 1 }}>
                  <span style={{ fontSize: 13, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>{review.name}</span>
                  <div style={{ display: "flex", alignItems: "center", gap: 4, marginTop: 1 }}>
                    {[1,2,3,4,5].map(s => (
                      <span key={s} style={{ fontSize: 9, color: s <= review.rating ? COLORS.accent : COLORS.beige }}>★</span>
                    ))}
                    <span style={{ fontSize: 10, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", marginLeft: 4 }}>{review.date}</span>
                  </div>
                </div>
              </div>
              <p style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", lineHeight: 1.5, margin: 0 }}>{review.text}</p>
            </div>
          ))}
        </div>

        {/* You May Also Like */}
        <div style={{ marginBottom: 20 }}>
          <h3 style={{ fontSize: 17, color: COLORS.darkBrown, margin: "0 0 14px", fontWeight: 400 }}>You May Also Like</h3>
          <div style={{ display: "flex", gap: 12, overflowX: "auto", marginLeft: -24, marginRight: -24, paddingLeft: 24, paddingRight: 24, paddingBottom: 4 }}>
            {related.map(p => (
              <div key={p.id} onClick={() => onProductClick && onProductClick(p)} style={{
                minWidth: 140, background: COLORS.white, borderRadius: 16,
                border: `1px solid ${COLORS.beige}`, overflow: "hidden",
                cursor: "pointer", flexShrink: 0,
                boxShadow: `0 2px 8px ${COLORS.shadow}`,
              }}>
                <div style={{
                  height: 90, display: "flex", alignItems: "center", justifyContent: "center",
                  background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
                  fontSize: 40,
                }}>{p.image}</div>
                <div style={{ padding: "10px 12px" }}>
                  <p style={{ fontSize: 13, color: COLORS.darkBrown, margin: 0, fontWeight: 400, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{p.name}</p>
                  <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 6 }}>
                    <span style={{ fontSize: 14, color: COLORS.darkBrown }}>${p.price.toFixed(2)}</span>
                    <span style={{ fontSize: 10, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>{p.time}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Bottom CTA */}
      <div style={{
        position: "absolute", bottom: 0, left: 0, right: 0, padding: "16px 24px 28px",
        background: `linear-gradient(to top, ${COLORS.warmWhite} 80%, transparent)`, zIndex: 5,
      }}>
        <button onClick={() => onAddToCart(product, quantity)} style={{
          width: "100%", padding: "18px 0", borderRadius: 18, border: "none", cursor: "pointer",
          background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          color: COLORS.cream, fontSize: 16, fontFamily: "'DM Serif Display', serif",
          letterSpacing: 0.5, boxShadow: "0 8px 30px rgba(74,55,40,0.25)",
          display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
        }}>
          Add to Cart — ${(product.price * quantity).toFixed(2)}
        </button>
      </div>
    </div>
  );
}

function CartScreen({ cart, onBack, onCheckout, onUpdateQuantity, onQuickAdd, selectedAddress, onAddressOpen }) {
  const total = cart.reduce((sum, item) => sum + item.product.price * item.quantity, 0);
  const [loaded, setLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  // Products not in cart for suggestions
  const cartIds = cart.map(c => c.product.id);
  const suggestions = products.filter(p => !cartIds.includes(p.id)).slice(0, 4);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 24px 16px", flexShrink: 0 }}>
        <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 14, background: COLORS.beige, border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Your Cart</h1>
        {cart.length > 0 && <span style={{ marginLeft: "auto", fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>{cart.length} item{cart.length !== 1 ? "s" : ""}</span>}
      </div>

      {/* Items */}
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 140px" }}>
        {cart.length === 0 ? (
          <div style={{ textAlign: "center", padding: "48px 0", opacity: loaded ? 1 : 0, transition: "opacity 0.5s" }}>
            <div style={{ fontSize: 64, marginBottom: 16 }}>🧺</div>
            <h2 style={{ fontSize: 20, color: COLORS.darkBrown, margin: "0 0 6px", fontWeight: 400 }}>Your cart is empty</h2>
            <p style={{ fontSize: 14, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 24px" }}>Looks like you haven't added anything yet</p>
            <button onClick={onBack} style={{
              padding: "14px 32px", borderRadius: 14, border: "none", cursor: "pointer",
              background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
              color: COLORS.cream, fontSize: 14, fontFamily: "'DM Serif Display', serif",
              letterSpacing: 0.5, boxShadow: "0 6px 20px rgba(74,55,40,0.2)",
            }}>Browse Menu</button>

            {/* Suggestions in empty state */}
            <div style={{ marginTop: 36, textAlign: "left" }}>
              <h3 style={{ fontSize: 16, color: COLORS.darkBrown, margin: "0 0 14px", fontWeight: 400 }}>Popular Right Now</h3>
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                {products.filter(p => p.badge).slice(0, 3).map(p => (
                  <div key={p.id} onClick={() => onQuickAdd && onQuickAdd(p)} style={{
                    display: "flex", alignItems: "center", gap: 12, padding: 12,
                    background: COLORS.white, borderRadius: 14, border: `1px solid ${COLORS.beige}`,
                    cursor: "pointer",
                  }}>
                    <div style={{
                      width: 48, height: 48, borderRadius: 12, fontSize: 24,
                      background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
                      display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
                    }}>{p.image}</div>
                    <div style={{ flex: 1 }}>
                      <p style={{ fontSize: 14, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{p.name}</p>
                      <p style={{ fontSize: 13, color: COLORS.softBrown, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>${p.price.toFixed(2)}</p>
                    </div>
                    <div style={{
                      width: 32, height: 32, borderRadius: 10, background: COLORS.darkBrown,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      color: COLORS.cream, fontSize: 16, fontWeight: 300, flexShrink: 0,
                    }}>+</div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        ) : (
          <>
            {cart.map((item, i) => (
              <div key={i} style={{
                display: "flex", gap: 14, padding: 16, marginBottom: 12,
                background: COLORS.white, borderRadius: 18, border: `1px solid ${COLORS.beige}`,
                opacity: loaded ? 1 : 0, transform: loaded ? "translateX(0)" : "translateX(-15px)",
                transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${i * 0.1}s`,
              }}>
                <div style={{
                  width: 70, height: 70, borderRadius: 14, flexShrink: 0,
                  background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
                  display: "flex", alignItems: "center", justifyContent: "center", fontSize: 34,
                }}>{item.product.image}</div>
                <div style={{ flex: 1 }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                    <h3 style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{item.product.name}</h3>
                    <button onClick={() => onUpdateQuantity(i, 0)} style={{
                      background: "none", border: "none", cursor: "pointer", padding: 2,
                    }}>
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={COLORS.textLight} strokeWidth="2" strokeLinecap="round">
                        <polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                      </svg>
                    </button>
                  </div>
                  <p style={{ fontSize: 16, color: COLORS.darkBrown, margin: "4px 0 8px" }}>${(item.product.price * item.quantity).toFixed(2)}</p>
                  <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                    <button onClick={() => onUpdateQuantity(i, Math.max(1, item.quantity - 1))} style={{
                      width: 28, height: 28, borderRadius: 8, border: `1px solid ${COLORS.beige}`, background: "transparent",
                      color: COLORS.softBrown, fontSize: 14, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
                    }}>−</button>
                    <span style={{ fontSize: 14, fontFamily: "'DM Sans', sans-serif", fontWeight: 600, color: COLORS.darkBrown }}>{item.quantity}</span>
                    <button onClick={() => onUpdateQuantity(i, item.quantity + 1)} style={{
                      width: 28, height: 28, borderRadius: 8, border: "none", background: COLORS.darkBrown,
                      color: COLORS.cream, fontSize: 14, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
                    }}>+</button>
                  </div>
                </div>
              </div>
            ))}

            {/* Add More Suggestion */}
            {suggestions.length > 0 && (
              <div style={{ marginTop: 8, marginBottom: 12, opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease 0.3s" }}>
                <h3 style={{ fontSize: 15, color: COLORS.darkBrown, margin: "0 0 10px", fontWeight: 400 }}>Add something extra?</h3>
                <div style={{ display: "flex", gap: 10, overflowX: "auto", marginLeft: -24, marginRight: -24, paddingLeft: 24, paddingRight: 24, paddingBottom: 4 }}>
                  {suggestions.map(p => (
                    <div key={p.id} onClick={() => onQuickAdd && onQuickAdd(p)} style={{
                      minWidth: 120, padding: 10, background: COLORS.white, borderRadius: 14,
                      border: `1px solid ${COLORS.beige}`, cursor: "pointer", flexShrink: 0,
                      textAlign: "center",
                    }}>
                      <div style={{
                        width: "100%", height: 56, borderRadius: 10, marginBottom: 8,
                        background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
                        display: "flex", alignItems: "center", justifyContent: "center", fontSize: 28,
                      }}>{p.image}</div>
                      <p style={{ fontSize: 12, color: COLORS.darkBrown, margin: "0 0 4px", fontWeight: 400, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{p.name}</p>
                      <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 6 }}>
                        <span style={{ fontSize: 13, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif" }}>${p.price.toFixed(2)}</span>
                        <div style={{
                          width: 22, height: 22, borderRadius: 7, background: COLORS.darkBrown,
                          display: "flex", alignItems: "center", justifyContent: "center",
                          color: COLORS.cream, fontSize: 13, fontWeight: 300,
                        }}>+</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Address */}
            <div style={{ marginTop: 4, marginBottom: 8, opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease 0.25s" }}>
              <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 8px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Deliver to</p>
              <AddressSelector selectedAddress={selectedAddress} onOpen={onAddressOpen} variant="compact" />
            </div>

            {/* Price Summary */}
            <div style={{
              background: COLORS.beige, borderRadius: 18, padding: 20, marginTop: 8,
              opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease 0.3s",
            }}>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 10, fontFamily: "'DM Sans', sans-serif" }}>
                <span style={{ fontSize: 14, color: COLORS.textLight }}>Subtotal</span>
                <span style={{ fontSize: 14, color: COLORS.darkBrown }}>${total.toFixed(2)}</span>
              </div>
              <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 10, fontFamily: "'DM Sans', sans-serif" }}>
                <span style={{ fontSize: 14, color: COLORS.textLight }}>Baking fee</span>
                <span style={{ fontSize: 14, color: COLORS.darkBrown }}>$2.50</span>
              </div>
              <div style={{ height: 1, background: COLORS.golden, opacity: 0.3, margin: "12px 0" }} />
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span style={{ fontSize: 17, color: COLORS.darkBrown }}>Total</span>
                <span style={{ fontSize: 20, color: COLORS.darkBrown }}>${(total + 2.50).toFixed(2)}</span>
              </div>
            </div>
          </>
        )}
      </div>

      {/* Checkout Button */}
      {cart.length > 0 && (
        <div style={{
          position: "absolute", bottom: 0, left: 0, right: 0, padding: "16px 24px 28px",
          background: `linear-gradient(to top, ${COLORS.warmWhite} 80%, transparent)`, zIndex: 5,
        }}>
          <button onClick={onCheckout} style={{
            width: "100%", padding: "18px 0", borderRadius: 18, border: "none", cursor: "pointer",
            background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
            color: COLORS.cream, fontSize: 16, fontFamily: "'DM Serif Display', serif",
            letterSpacing: 0.5, boxShadow: "0 8px 30px rgba(74,55,40,0.25)",
          }}>
            Checkout — ${(total + 2.50).toFixed(2)}
          </button>
        </div>
      )}
    </div>
  );
}

function CheckoutScreen({ cart, onBack, onPlaceOrder, selectedAddress }) {
  const total = cart.reduce((sum, item) => sum + item.product.price * item.quantity, 0) + 2.50;
  const [step, setStep] = useState(1);
  const [loaded, setLoaded] = useState(false);
  const [selectedPayment, setSelectedPayment] = useState(0);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const addr = savedAddresses.find(a => a.id === selectedAddress) || savedAddresses[0];

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 24px 16px", flexShrink: 0 }}>
        <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 14, background: COLORS.beige, border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Checkout</h1>
      </div>

      {/* Step indicator */}
      <div style={{ display: "flex", gap: 6, padding: "0 24px 20px", flexShrink: 0 }}>
        {[addr.type === "Pickup" ? "Pickup" : "Delivery", "Payment", "Confirm"].map((s, i) => (
          <div key={i} style={{ flex: 1, textAlign: "center" }}>
            <div style={{
              height: 3, borderRadius: 2, marginBottom: 6,
              background: i + 1 <= step ? COLORS.darkBrown : COLORS.beige,
              transition: "background 0.4s ease",
            }} />
            <span style={{
              fontSize: 11, fontFamily: "'DM Sans', sans-serif",
              color: i + 1 <= step ? COLORS.darkBrown : COLORS.textLight, fontWeight: i + 1 === step ? 600 : 400,
            }}>{s}</span>
          </div>
        ))}
      </div>

      {/* Content */}
      <div style={{
        flex: 1, overflowY: "auto", padding: "0 24px 120px",
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(15px)",
        transition: "all 0.5s cubic-bezier(0.22,1,0.36,1)",
      }}>
        {step === 1 && (
          <div>
            <h3 style={{ fontSize: 16, color: COLORS.darkBrown, margin: "0 0 16px", fontWeight: 400 }}>{addr.type === "Pickup" ? "Pickup" : "Delivery"} Details</h3>
            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              <div style={{ background: COLORS.white, borderRadius: 16, padding: "14px 18px", border: `1.5px solid ${COLORS.beige}` }}>
                <label style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", letterSpacing: 0.5, textTransform: "uppercase" }}>{addr.type === "Pickup" ? "Pickup Location" : "Delivery Address"}</label>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 6 }}>
                  <span style={{ fontSize: 16 }}>{addr.icon}</span>
                  <div>
                    <span style={{ fontSize: 14, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>{addr.label}</span>
                    <span style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", display: "block", marginTop: 1 }}>{addr.address}</span>
                  </div>
                </div>
              </div>
              <div style={{ background: COLORS.white, borderRadius: 16, padding: "14px 18px", border: `1.5px solid ${COLORS.beige}` }}>
                <label style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", letterSpacing: 0.5, textTransform: "uppercase" }}>{addr.type === "Pickup" ? "Pickup" : "Delivery"} Time</label>
                <div style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 6 }}>
                  <span style={{ fontSize: 16 }}>🕐</span>
                  <span style={{ fontSize: 14, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif" }}>Today, 11:00 AM - 11:30 AM</span>
                </div>
              </div>
              <div style={{ background: COLORS.white, borderRadius: 16, padding: "14px 18px", border: `1.5px solid ${COLORS.beige}` }}>
                <label style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", letterSpacing: 0.5, textTransform: "uppercase" }}>Special Instructions</label>
                <textarea placeholder="Any special requests for your order..." style={{
                  border: "none", outline: "none", width: "100%", fontSize: 14, color: COLORS.text,
                  fontFamily: "'DM Sans', sans-serif", background: "transparent", marginTop: 6,
                  resize: "none", height: 50,
                }} />
              </div>
            </div>
          </div>
        )}
        {step === 2 && (
          <div>
            <h3 style={{ fontSize: 16, color: COLORS.darkBrown, margin: "0 0 16px", fontWeight: 400 }}>Payment Method</h3>
            {[
              { icon: "💳", label: "•••• 4289", sub: "Visa ending in 4289" },
              { icon: "🍎", label: "Apple Pay", sub: "Express checkout" },
            ].map((pm, i) => (
              <div key={i} onClick={() => setSelectedPayment(i)} style={{
                display: "flex", alignItems: "center", gap: 14, padding: 16, marginBottom: 10,
                background: selectedPayment === i ? COLORS.white : "transparent", borderRadius: 16,
                border: `1.5px solid ${selectedPayment === i ? COLORS.darkBrown : COLORS.beige}`,
                cursor: "pointer", transition: "all 0.25s ease",
              }}>
                <div style={{ width: 44, height: 44, borderRadius: 14, background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 20 }}>{pm.icon}</div>
                <div>
                  <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>{pm.label}</p>
                  <p style={{ fontSize: 12, color: COLORS.textLight, margin: "2px 0 0", fontFamily: "'DM Sans', sans-serif" }}>{pm.sub}</p>
                </div>
                {selectedPayment === i && <div style={{ marginLeft: "auto", width: 20, height: 20, borderRadius: 10, background: COLORS.darkBrown, display: "flex", alignItems: "center", justifyContent: "center" }}>
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke={COLORS.cream} strokeWidth="3"><polyline points="20 6 9 17 4 12"/></svg>
                </div>}
              </div>
            ))}
          </div>
        )}
        {step === 3 && (
          <div>
            <h3 style={{ fontSize: 16, color: COLORS.darkBrown, margin: "0 0 16px", fontWeight: 400 }}>Order Summary</h3>
            <div style={{ background: COLORS.white, borderRadius: 18, padding: 20, border: `1px solid ${COLORS.beige}` }}>
              {cart.map((item, i) => (
                <div key={i} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: i < cart.length - 1 ? 12 : 0 }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                    <span style={{ fontSize: 22 }}>{item.product.image}</span>
                    <div>
                      <span style={{ fontSize: 14, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif" }}>{item.product.name}</span>
                      <span style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", display: "block" }}>× {item.quantity}</span>
                    </div>
                  </div>
                  <span style={{ fontSize: 14, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>${(item.product.price * item.quantity).toFixed(2)}</span>
                </div>
              ))}
              <div style={{ height: 1, background: COLORS.beige, margin: "16px 0" }} />
              <div style={{ display: "flex", justifyContent: "space-between" }}>
                <span style={{ fontSize: 17, color: COLORS.darkBrown }}>Total</span>
                <span style={{ fontSize: 20, color: COLORS.darkBrown }}>${total.toFixed(2)}</span>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Bottom CTA */}
      <div style={{
        position: "absolute", bottom: 0, left: 0, right: 0, padding: "16px 24px 28px",
        background: `linear-gradient(to top, ${COLORS.warmWhite} 80%, transparent)`, zIndex: 5,
      }}>
        <button onClick={() => step < 3 ? setStep(step + 1) : onPlaceOrder()} style={{
          width: "100%", padding: "18px 0", borderRadius: 18, border: "none", cursor: "pointer",
          background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          color: COLORS.cream, fontSize: 16, fontFamily: "'DM Serif Display', serif",
          letterSpacing: 0.5, boxShadow: "0 8px 30px rgba(74,55,40,0.25)",
        }}>
          {step < 3 ? "Continue" : `Place Order — $${total.toFixed(2)}`}
        </button>
      </div>
    </div>
  );
}

function RecentOrdersScreen({ onBack, onReorder }) {
  const [loaded, setLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 24px 16px", flexShrink: 0 }}>
        <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 14, background: COLORS.beige, border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Recent Orders</h1>
      </div>

      <div style={{
        flex: 1, overflowY: "auto", padding: "0 24px 40px",
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(15px)",
        transition: "all 0.6s cubic-bezier(0.22,1,0.36,1)",
      }}>
        {/* Summary Card */}
        <div style={{
          background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          borderRadius: 22, padding: 24, marginBottom: 24,
        }}>
          <p style={{ color: COLORS.golden, fontSize: 11, fontFamily: "'DM Sans', sans-serif", margin: 0, letterSpacing: 1.5, textTransform: "uppercase", fontWeight: 500 }}>This Month</p>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", marginTop: 10 }}>
            <div>
              <p style={{ color: COLORS.cream, fontSize: 32, margin: 0, fontWeight: 400 }}>4</p>
              <p style={{ color: "rgba(255,255,255,0.5)", fontSize: 13, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>orders placed</p>
            </div>
            <div style={{ textAlign: "right" }}>
              <p style={{ color: COLORS.cream, fontSize: 24, margin: 0, fontWeight: 400 }}>$86.50</p>
              <p style={{ color: "rgba(255,255,255,0.5)", fontSize: 13, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>total spent</p>
            </div>
          </div>
        </div>

        {/* Order List */}
        {recentOrders.map((order, i) => (
          <div key={order.id} style={{
            background: COLORS.white, borderRadius: 20, padding: 18,
            marginBottom: 12, border: `1px solid ${COLORS.beige}`,
            opacity: loaded ? 1 : 0,
            transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${0.15 + i * 0.1}s`,
          }}>
            {/* Order header */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14 }}>
              <div>
                <span style={{ fontSize: 15, color: COLORS.darkBrown, fontWeight: 400 }}>Order {order.id}</span>
                <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "3px 0 0" }}>{order.date}</p>
              </div>
              <span style={{
                fontSize: 11, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                padding: "5px 12px", borderRadius: 10,
                background: `${COLORS.sage}18`, color: COLORS.sage,
              }}>
                ✓ {order.status}
              </span>
            </div>

            {/* Items */}
            <div style={{ display: "flex", flexDirection: "column", gap: 6, marginBottom: 14 }}>
              {order.items.map((item, j) => (
                <div key={j} style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                  <span style={{ fontSize: 14, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif" }}>{item.name}</span>
                  <span style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>× {item.qty}</span>
                </div>
              ))}
            </div>

            {/* Footer */}
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", paddingTop: 12, borderTop: `1px solid ${COLORS.beige}` }}>
              <span style={{ fontSize: 17, color: COLORS.darkBrown }}>${order.total.toFixed(2)}</span>
              <button onClick={() => onReorder && onReorder(order)} style={{
                padding: "8px 18px", borderRadius: 12, border: `1.5px solid ${COLORS.darkBrown}`,
                background: "transparent", cursor: "pointer",
                fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                color: COLORS.darkBrown, transition: "all 0.2s ease",
              }}>Reorder</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function ProfileScreen({ onNavigate, cartCount, onOrdersClick, onFavouritesClick, onSubScreen }) {
  const [loaded, setLoaded] = useState(false);
  const [showSignOut, setShowSignOut] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const menuItems = [
    { icon: "📋", label: "Recent Orders", sub: "View your order history", action: onOrdersClick },
    { icon: "❤️", label: "Favorites", sub: "Your saved items", action: onFavouritesClick },
    { icon: "📍", label: "Saved Addresses", sub: "Manage pickup locations", action: () => onSubScreen("addresses") },
    { icon: "💳", label: "Payment Methods", sub: "Cards & digital wallets", action: () => onSubScreen("payments") },
    { icon: "🔔", label: "Notifications", sub: "Order updates & offers", action: () => onSubScreen("notifications") },
    { icon: "⚙️", label: "Settings", sub: "App preferences", action: () => onSubScreen("settings") },
  ];

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Scrollable content */}
      <div style={{
        flex: 1, overflowY: "auto", padding: "8px 24px 100px",
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(15px)",
        transition: "all 0.6s cubic-bezier(0.22,1,0.36,1)",
      }}>
        {/* Profile Card */}
        <div onClick={() => onSubScreen("edit-profile")} style={{
          display: "flex", alignItems: "center", gap: 16, marginBottom: 28, cursor: "pointer",
        }}>
          <div style={{
            width: 64, height: 64, borderRadius: 22, flexShrink: 0,
            background: `linear-gradient(135deg, ${COLORS.golden}, ${COLORS.caramel})`,
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: 28, boxShadow: "0 4px 15px rgba(74,55,40,0.15)",
          }}>👤</div>
          <div style={{ flex: 1 }}>
            <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Guest Baker</h1>
            <p style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "3px 0 0" }}>member since Feb 2026</p>
          </div>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={COLORS.textLight} strokeWidth="2" strokeLinecap="round"><polyline points="9 18 15 12 9 6"/></svg>
        </div>

        {/* Loyalty Card */}
        <div style={{
          background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          borderRadius: 22, padding: 22, marginBottom: 28,
        }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
            <div>
              <p style={{ color: COLORS.golden, fontSize: 11, fontFamily: "'DM Sans', sans-serif", margin: 0, letterSpacing: 1.5, textTransform: "uppercase", fontWeight: 500 }}>Loyalty Points</p>
              <p style={{ color: COLORS.cream, fontSize: 28, margin: "4px 0 0", fontWeight: 400 }}>340 pts</p>
            </div>
            <div style={{ fontSize: 36 }}>🏅</div>
          </div>
          <div style={{ background: "rgba(255,255,255,0.12)", borderRadius: 6, height: 6, overflow: "hidden" }}>
            <div style={{ width: loaded ? "68%" : "0%", height: "100%", borderRadius: 6, background: `linear-gradient(90deg, ${COLORS.golden}, ${COLORS.caramel})`, transition: "width 1.2s cubic-bezier(0.22,1,0.36,1) 0.3s" }} />
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 10 }}>
            <p style={{ color: "rgba(255,255,255,0.5)", fontSize: 12, fontFamily: "'DM Sans', sans-serif", margin: 0 }}>160 pts to next reward</p>
            <p style={{ color: COLORS.golden, fontSize: 12, fontFamily: "'DM Sans', sans-serif", margin: 0, fontWeight: 500 }}>500 pts</p>
          </div>
          {/* Next reward */}
          <div style={{
            display: "flex", alignItems: "center", gap: 8, marginTop: 14, padding: "10px 14px",
            background: "rgba(255,255,255,0.08)", borderRadius: 12,
          }}>
            <span style={{ fontSize: 18 }}>🥐</span>
            <div style={{ flex: 1 }}>
              <p style={{ color: COLORS.cream, fontSize: 13, fontFamily: "'DM Sans', sans-serif", margin: 0, fontWeight: 500 }}>Next: Free Croissant</p>
              <p style={{ color: "rgba(255,255,255,0.4)", fontSize: 11, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>Then 🎂 Free Slice at 750 · 👑 VIP at 1000</p>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
          {menuItems.map((item, i) => (
            <div key={i} onClick={item.action} style={{
              display: "flex", alignItems: "center", gap: 14, padding: "14px 4px",
              cursor: "pointer",
              borderBottom: i < menuItems.length - 1 ? `1px solid ${COLORS.beige}` : "none",
              opacity: loaded ? 1 : 0,
              transition: `opacity 0.4s ease ${0.1 + i * 0.06}s`,
            }}>
              <div style={{
                width: 42, height: 42, borderRadius: 14, fontSize: 18,
                background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center",
              }}>{item.icon}</div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{item.label}</p>
                <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{item.sub}</p>
              </div>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={COLORS.textLight} strokeWidth="2" strokeLinecap="round"><polyline points="9 18 15 12 9 6"/></svg>
            </div>
          ))}
        </div>

        {/* Sign Out */}
        <button onClick={() => setShowSignOut(true)} style={{
          width: "100%", padding: "14px 0", marginTop: 24, borderRadius: 14,
          border: `1.5px solid ${COLORS.beige}`, background: "transparent",
          cursor: "pointer", fontSize: 14, fontFamily: "'DM Sans', sans-serif",
          fontWeight: 500, color: COLORS.terracotta,
        }}>Sign Out</button>
      </div>

      {/* Sign Out Confirm Modal */}
      {showSignOut && (
        <>
          <div onClick={() => setShowSignOut(false)} style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.35)", zIndex: 60 }} />
          <div style={{
            position: "fixed", bottom: 0, left: 0, right: 0, zIndex: 61,
            background: COLORS.warmWhite, borderRadius: "24px 24px 0 0",
            padding: "28px 24px 36px", textAlign: "center",
            boxShadow: "0 -10px 40px rgba(0,0,0,0.12)",
          }}>
            <div style={{ width: 40, height: 4, borderRadius: 2, background: COLORS.beige, margin: "0 auto 20px" }} />
            <div style={{ fontSize: 40, marginBottom: 12 }}>👋</div>
            <h3 style={{ fontSize: 20, color: COLORS.darkBrown, margin: "0 0 8px", fontWeight: 400 }}>Sign Out?</h3>
            <p style={{ fontSize: 14, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 24px" }}>
              You'll need to sign back in to access your orders and loyalty points.
            </p>
            <button onClick={() => setShowSignOut(false)} style={{
              width: "100%", padding: "16px 0", borderRadius: 14, border: "none", cursor: "pointer",
              background: COLORS.terracotta, color: COLORS.white,
              fontSize: 15, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
              marginBottom: 10, boxShadow: `0 4px 15px ${COLORS.terracotta}40`,
            }}>Sign Out</button>
            <button onClick={() => setShowSignOut(false)} style={{
              width: "100%", padding: "14px 0", borderRadius: 14,
              border: `1.5px solid ${COLORS.beige}`, background: "transparent",
              cursor: "pointer", fontSize: 14, fontFamily: "'DM Sans', sans-serif",
              fontWeight: 500, color: COLORS.darkBrown,
            }}>Cancel</button>
          </div>
        </>
      )}

      {/* Bottom Nav */}
      <BottomNav active="profile" onNavigate={onNavigate} cartCount={cartCount} />
    </div>
  );
}

// ========== PROFILE SUB-SCREENS ==========

function ProfileSubHeader({ title, onBack }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 24px 16px", flexShrink: 0 }}>
      <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 14, background: COLORS.beige, border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
      </button>
      <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{title}</h1>
    </div>
  );
}

function EditProfileScreen({ onBack }) {
  const [loaded, setLoaded] = useState(false);
  const [name, setName] = useState("Guest Baker");
  const [email, setEmail] = useState("guest@bakery.com");
  const [phone, setPhone] = useState("+1 (555) 012-3456");
  const [birthday, setBirthday] = useState("1990-03-15");
  const [bio, setBio] = useState("");
  const [saved, setSaved] = useState(false);
  const [dietaryPrefs, setDietaryPrefs] = useState(["None"]);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const dietaryOptions = ["None", "Vegan", "Gluten-Free", "Nut-Free", "Dairy-Free", "Low Sugar"];

  const toggleDietary = (opt) => {
    setSaved(false);
    if (opt === "None") { setDietaryPrefs(["None"]); return; }
    let next = dietaryPrefs.filter(d => d !== "None");
    if (next.includes(opt)) next = next.filter(d => d !== opt);
    else next = [...next, opt];
    setDietaryPrefs(next.length === 0 ? ["None"] : next);
  };

  const inputStyle = {
    width: "100%", padding: "14px 16px", borderRadius: 14, fontSize: 15,
    fontFamily: "'DM Sans', sans-serif", color: COLORS.darkBrown,
    border: `1.5px solid ${COLORS.beige}`, background: COLORS.white,
    outline: "none", boxSizing: "border-box",
    transition: "border-color 0.2s ease",
  };

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="Edit Profile" onBack={onBack} />
      <div style={{
        flex: 1, overflowY: "auto", padding: "0 24px 40px",
        opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease",
      }}>
        {/* Avatar */}
        <div style={{ textAlign: "center", marginBottom: 28 }}>
          <div style={{
            width: 96, height: 96, borderRadius: 32, margin: "0 auto 12px",
            background: `linear-gradient(135deg, ${COLORS.golden}, ${COLORS.caramel})`,
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: 44, boxShadow: "0 6px 20px rgba(74,55,40,0.15)",
            position: "relative",
          }}>
            👤
            <div style={{
              position: "absolute", bottom: -2, right: -2,
              width: 30, height: 30, borderRadius: 11, background: COLORS.darkBrown,
              display: "flex", alignItems: "center", justifyContent: "center",
              border: `3px solid ${COLORS.warmWhite}`, cursor: "pointer",
            }}>
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke={COLORS.cream} strokeWidth="2.5" strokeLinecap="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
            </div>
          </div>
          <p style={{ fontSize: 13, color: COLORS.caramel, fontFamily: "'DM Sans', sans-serif", cursor: "pointer", fontWeight: 500 }}>Change Photo</p>
          <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "4px 0 0" }}>Member since Feb 2026</p>
        </div>

        {/* Personal Info */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 12px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Personal Information</p>

        {[
          { label: "Full Name", val: name, set: setName, icon: "👤" },
          { label: "Email", val: email, set: setEmail, type: "email", icon: "✉️" },
          { label: "Phone", val: phone, set: setPhone, type: "tel", icon: "📱" },
        ].map((f, i) => (
          <div key={i} style={{ marginBottom: 16 }}>
            <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>{f.label}</label>
            <div style={{ position: "relative" }}>
              <span style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)", fontSize: 14 }}>{f.icon}</span>
              <input
                type={f.type || "text"} value={f.val}
                onChange={(e) => { f.set(e.target.value); setSaved(false); }}
                style={{ ...inputStyle, paddingLeft: 40 }}
                onFocus={(e) => e.target.style.borderColor = COLORS.caramel}
                onBlur={(e) => e.target.style.borderColor = COLORS.beige}
              />
            </div>
          </div>
        ))}

        {/* Birthday */}
        <div style={{ marginBottom: 16 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>Birthday</label>
          <div style={{ position: "relative" }}>
            <span style={{ position: "absolute", left: 14, top: "50%", transform: "translateY(-50%)", fontSize: 14 }}>🎂</span>
            <input
              type="date" value={birthday}
              onChange={(e) => { setBirthday(e.target.value); setSaved(false); }}
              style={{ ...inputStyle, paddingLeft: 40 }}
              onFocus={(e) => e.target.style.borderColor = COLORS.caramel}
              onBlur={(e) => e.target.style.borderColor = COLORS.beige}
            />
          </div>
          <p style={{ fontSize: 11, color: COLORS.sage, fontFamily: "'DM Sans', sans-serif", margin: "6px 0 0 2px" }}>🎁 Get a free pastry on your birthday!</p>
        </div>

        {/* Bio */}
        <div style={{ marginBottom: 24 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>About Me</label>
          <textarea
            value={bio}
            onChange={(e) => { setBio(e.target.value); setSaved(false); }}
            placeholder="Tell us about your baking preferences..."
            style={{
              ...inputStyle, height: 80, resize: "none",
              fontFamily: "'DM Sans', sans-serif",
            }}
            onFocus={(e) => e.target.style.borderColor = COLORS.caramel}
            onBlur={(e) => e.target.style.borderColor = COLORS.beige}
          />
          <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "4px 0 0", textAlign: "right" }}>{bio.length}/150</p>
        </div>

        {/* Dietary Preferences */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 10px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Dietary Preferences</p>
        <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 12px", lineHeight: 1.4 }}>We'll highlight suitable items and flag allergens for you</p>
        <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginBottom: 28 }}>
          {dietaryOptions.map(opt => {
            const active = dietaryPrefs.includes(opt);
            return (
              <button key={opt} onClick={() => toggleDietary(opt)} style={{
                padding: "9px 16px", borderRadius: 12, border: "none", cursor: "pointer",
                background: active ? COLORS.darkBrown : COLORS.beige,
                color: active ? COLORS.cream : COLORS.softBrown,
                fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                transition: "all 0.25s ease",
              }}>{opt}</button>
            );
          })}
        </div>

        {/* Save Button */}
        <button onClick={() => setSaved(true)} style={{
          width: "100%", padding: "16px 0", borderRadius: 16, border: "none", cursor: "pointer",
          background: saved ? COLORS.sage : `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          color: COLORS.cream, fontSize: 15, fontFamily: "'DM Serif Display', serif",
          letterSpacing: 0.5, boxShadow: "0 6px 20px rgba(74,55,40,0.2)",
          transition: "all 0.3s ease",
        }}>{saved ? "✓ Saved" : "Save Changes"}</button>
      </div>
    </div>
  );
}

function SavedAddressesScreen({ onBack, selectedAddress, onAddressSelect, onAddNew }) {
  const [loaded, setLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="Saved Addresses" onBack={onBack} />
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 40px", opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease" }}>
        {savedAddresses.map((addr, i) => (
          <div key={addr.id} onClick={() => onAddressSelect(addr.id)} style={{
            display: "flex", gap: 14, padding: 18, marginBottom: 12,
            background: COLORS.white, borderRadius: 18,
            border: `1.5px solid ${selectedAddress === addr.id ? COLORS.darkBrown : COLORS.beige}`,
            cursor: "pointer",
            opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(10px)",
            transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${i * 0.08}s`,
          }}>
            <div style={{
              width: 44, height: 44, borderRadius: 14, fontSize: 20,
              background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center",
            }}>{addr.icon}</div>
            <div style={{ flex: 1 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 500, fontFamily: "'DM Sans', sans-serif" }}>{addr.label}</p>
                <span style={{
                  fontSize: 10, padding: "2px 8px", borderRadius: 6,
                  background: addr.type === "Pickup" ? `${COLORS.sage}22` : `${COLORS.golden}30`,
                  color: addr.type === "Pickup" ? COLORS.sage : COLORS.softBrown,
                  fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                }}>{addr.type}</span>
                {selectedAddress === addr.id && (
                  <span style={{ fontSize: 10, padding: "2px 8px", borderRadius: 6, background: `${COLORS.darkBrown}15`, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 600 }}>Default</span>
                )}
              </div>
              <p style={{ fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "4px 0 0", lineHeight: 1.4 }}>{addr.address}</p>
            </div>
            {selectedAddress === addr.id && (
              <div style={{ alignSelf: "center" }}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.sage} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
              </div>
            )}
          </div>
        ))}
        {/* Add New */}
        <div onClick={onAddNew} style={{
          display: "flex", alignItems: "center", justifyContent: "center", gap: 10,
          padding: 18, borderRadius: 18, cursor: "pointer",
          border: `2px dashed ${COLORS.beige}`, color: COLORS.softBrown,
          fontSize: 14, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add New Address
        </div>
      </div>
    </div>
  );
}

function AddNewAddressScreen({ onBack, onSave }) {
  const [loaded, setLoaded] = useState(false);
  const [label, setLabel] = useState("");
  const [address, setAddress] = useState("");
  const [city, setCity] = useState("");
  const [postcode, setPostcode] = useState("");
  const [type, setType] = useState("Delivery");
  const [icon, setIcon] = useState("📍");
  const [saved, setSaved] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const icons = ["🏠", "💼", "🏡", "🏢", "🏫", "📍"];

  const inputStyle = {
    width: "100%", padding: "14px 16px", borderRadius: 14, fontSize: 15,
    fontFamily: "'DM Sans', sans-serif", color: COLORS.darkBrown,
    border: `1.5px solid ${COLORS.beige}`, background: COLORS.white,
    outline: "none", boxSizing: "border-box",
    transition: "border-color 0.2s ease",
  };

  const handleSave = () => {
    setSaved(true);
    setTimeout(() => onSave(), 800);
  };

  const isValid = label.trim() && address.trim();

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="New Address" onBack={onBack} />
      <div style={{
        flex: 1, overflowY: "auto", padding: "0 24px 40px",
        opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease",
      }}>
        {/* Map placeholder */}
        <div style={{
          width: "100%", height: 160, borderRadius: 18, marginBottom: 24,
          background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
          display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center",
          position: "relative", overflow: "hidden",
        }}>
          {/* Grid lines for map effect */}
          {[0,1,2,3,4].map(i => (
            <div key={`h${i}`} style={{ position: "absolute", left: 0, right: 0, top: `${20 + i * 20}%`, height: 1, background: `${COLORS.golden}20` }} />
          ))}
          {[0,1,2,3,4].map(i => (
            <div key={`v${i}`} style={{ position: "absolute", top: 0, bottom: 0, left: `${20 + i * 20}%`, width: 1, background: `${COLORS.golden}20` }} />
          ))}
          <div style={{
            width: 44, height: 44, borderRadius: 22,
            background: COLORS.white, boxShadow: "0 4px 15px rgba(0,0,0,0.12)",
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: 22, zIndex: 1,
          }}>📍</div>
          <p style={{ fontSize: 12, color: COLORS.softBrown, fontFamily: "'DM Sans', sans-serif", marginTop: 8, zIndex: 1 }}>Drag to adjust pin</p>
        </div>

        {/* Icon selector */}
        <div style={{ marginBottom: 20 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 8, display: "block", letterSpacing: 0.3 }}>Icon</label>
          <div style={{ display: "flex", gap: 8 }}>
            {icons.map(ic => (
              <div key={ic} onClick={() => setIcon(ic)} style={{
                width: 44, height: 44, borderRadius: 14, fontSize: 20, cursor: "pointer",
                background: icon === ic ? `${COLORS.darkBrown}12` : COLORS.beige,
                border: `2px solid ${icon === ic ? COLORS.darkBrown : "transparent"}`,
                display: "flex", alignItems: "center", justifyContent: "center",
                transition: "all 0.2s ease",
              }}>{ic}</div>
            ))}
          </div>
        </div>

        {/* Label */}
        <div style={{ marginBottom: 18 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>Label</label>
          <input
            value={label} onChange={e => setLabel(e.target.value)}
            placeholder="e.g. Home, Office, Gym"
            style={inputStyle}
            onFocus={e => e.target.style.borderColor = COLORS.caramel}
            onBlur={e => e.target.style.borderColor = COLORS.beige}
          />
        </div>

        {/* Street Address */}
        <div style={{ marginBottom: 18 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>Street Address</label>
          <input
            value={address} onChange={e => setAddress(e.target.value)}
            placeholder="123 Baker Street"
            style={inputStyle}
            onFocus={e => e.target.style.borderColor = COLORS.caramel}
            onBlur={e => e.target.style.borderColor = COLORS.beige}
          />
        </div>

        {/* City + Postcode row */}
        <div style={{ display: "flex", gap: 12, marginBottom: 18 }}>
          <div style={{ flex: 1 }}>
            <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>City</label>
            <input
              value={city} onChange={e => setCity(e.target.value)}
              placeholder="London"
              style={inputStyle}
              onFocus={e => e.target.style.borderColor = COLORS.caramel}
              onBlur={e => e.target.style.borderColor = COLORS.beige}
            />
          </div>
          <div style={{ flex: 1 }}>
            <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 6, display: "block", letterSpacing: 0.3 }}>Postcode</label>
            <input
              value={postcode} onChange={e => setPostcode(e.target.value)}
              placeholder="W1F 0TH"
              style={inputStyle}
              onFocus={e => e.target.style.borderColor = COLORS.caramel}
              onBlur={e => e.target.style.borderColor = COLORS.beige}
            />
          </div>
        </div>

        {/* Type selector */}
        <div style={{ marginBottom: 28 }}>
          <label style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, marginBottom: 8, display: "block", letterSpacing: 0.3 }}>Type</label>
          <div style={{ display: "flex", gap: 10 }}>
            {["Delivery", "Pickup"].map(t => (
              <button key={t} onClick={() => setType(t)} style={{
                flex: 1, padding: "12px 0", borderRadius: 14, border: "none", cursor: "pointer",
                background: type === t ? COLORS.darkBrown : COLORS.beige,
                color: type === t ? COLORS.cream : COLORS.softBrown,
                fontSize: 14, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                transition: "all 0.25s ease",
                boxShadow: type === t ? "0 4px 12px rgba(74,55,40,0.2)" : "none",
                display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
              }}>
                {t === "Delivery" ? "🚲" : "🏪"} {t}
              </button>
            ))}
          </div>
        </div>

        {/* Save button */}
        <button onClick={handleSave} disabled={!isValid && !saved} style={{
          width: "100%", padding: "16px 0", borderRadius: 16, border: "none", cursor: isValid || saved ? "pointer" : "not-allowed",
          background: saved ? COLORS.sage : isValid ? `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})` : COLORS.beige,
          color: saved ? COLORS.white : isValid ? COLORS.cream : COLORS.textLight,
          fontSize: 15, fontFamily: "'DM Serif Display', serif",
          letterSpacing: 0.5,
          boxShadow: isValid ? "0 6px 20px rgba(74,55,40,0.2)" : "none",
          transition: "all 0.3s ease",
        }}>{saved ? "✓ Address Saved" : "Save Address"}</button>
      </div>
    </div>
  );
}

function PaymentMethodsScreen({ onBack }) {
  const [loaded, setLoaded] = useState(false);
  const [selected, setSelected] = useState(0);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const methods = [
    { icon: "💳", label: "Visa •••• 4289", sub: "Expires 03/27", brand: "visa" },
    { icon: "🍎", label: "Apple Pay", sub: "Express checkout", brand: "apple" },
    { icon: "💳", label: "Mastercard •••• 8821", sub: "Expires 11/26", brand: "mc" },
  ];

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="Payment Methods" onBack={onBack} />
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 40px", opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease" }}>
        {methods.map((m, i) => (
          <div key={i} onClick={() => setSelected(i)} style={{
            display: "flex", alignItems: "center", gap: 14, padding: 18, marginBottom: 12,
            background: COLORS.white, borderRadius: 18,
            border: `1.5px solid ${selected === i ? COLORS.darkBrown : COLORS.beige}`,
            cursor: "pointer", transition: "all 0.25s ease",
          }}>
            <div style={{
              width: 44, height: 44, borderRadius: 14, fontSize: 20,
              background: selected === i ? `${COLORS.darkBrown}12` : COLORS.beige,
              display: "flex", alignItems: "center", justifyContent: "center",
            }}>{m.icon}</div>
            <div style={{ flex: 1 }}>
              <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 500, fontFamily: "'DM Sans', sans-serif" }}>{m.label}</p>
              <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{m.sub}</p>
            </div>
            {selected === i ? (
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.sage} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
            ) : (
              <div style={{ width: 18, height: 18, borderRadius: 9, border: `2px solid ${COLORS.beige}` }} />
            )}
          </div>
        ))}
        {/* Add New */}
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "center", gap: 10,
          padding: 18, borderRadius: 18, cursor: "pointer",
          border: `2px dashed ${COLORS.beige}`, color: COLORS.softBrown,
          fontSize: 14, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.softBrown} strokeWidth="2" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
          Add Payment Method
        </div>
      </div>
    </div>
  );
}

function NotificationsScreen({ onBack }) {
  const [loaded, setLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const [toggles, setToggles] = useState({
    orders: true, promos: true, ready: true, loyalty: false, news: false,
  });

  const toggle = (key) => setToggles(prev => ({ ...prev, [key]: !prev[key] }));

  const items = [
    { key: "orders", icon: "📋", label: "Order Updates", sub: "Status changes & confirmations" },
    { key: "ready", icon: "✅", label: "Ready for Pickup", sub: "Alert when your order is ready" },
    { key: "promos", icon: "🎉", label: "Promotions", sub: "Discounts & special offers" },
    { key: "loyalty", icon: "🏅", label: "Loyalty Rewards", sub: "Points earned & rewards available" },
    { key: "news", icon: "📰", label: "New Items", sub: "Fresh additions to our menu" },
  ];

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="Notifications" onBack={onBack} />
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 40px", opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease" }}>
        {items.map((item, i) => (
          <div key={item.key} style={{
            display: "flex", alignItems: "center", gap: 14, padding: "16px 4px",
            borderBottom: i < items.length - 1 ? `1px solid ${COLORS.beige}` : "none",
          }}>
            <div style={{
              width: 42, height: 42, borderRadius: 14, fontSize: 18,
              background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center",
            }}>{item.icon}</div>
            <div style={{ flex: 1 }}>
              <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{item.label}</p>
              <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{item.sub}</p>
            </div>
            {/* Toggle */}
            <div onClick={() => toggle(item.key)} style={{
              width: 48, height: 28, borderRadius: 14, cursor: "pointer",
              background: toggles[item.key] ? COLORS.sage : COLORS.beige,
              transition: "background 0.25s ease", position: "relative", flexShrink: 0,
            }}>
              <div style={{
                width: 22, height: 22, borderRadius: 11, background: COLORS.white,
                position: "absolute", top: 3,
                left: toggles[item.key] ? 23 : 3,
                transition: "left 0.25s ease",
                boxShadow: "0 1px 4px rgba(0,0,0,0.15)",
              }} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function SettingsScreen({ onBack }) {
  const [loaded, setLoaded] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const [lang, setLang] = useState("English");
  const [langOpen, setLangOpen] = useState(false);
  const [autoPlay, setAutoPlay] = useState(true);
  const [saveData, setSaveData] = useState(false);
  const [haptics, setHaptics] = useState(true);
  const [locationAccess, setLocationAccess] = useState(true);
  const [cacheCleared, setCacheCleared] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const languages = ["English", "Français", "Español", "Deutsch", "Italiano", "Português", "日本語", "中文"];

  const ToggleRow = ({ icon, label, sub, on, onToggle, disabled }) => (
    <div style={{ display: "flex", alignItems: "center", gap: 14, padding: "16px 4px", borderBottom: `1px solid ${COLORS.beige}`, opacity: disabled ? 0.5 : 1 }}>
      <div style={{ width: 42, height: 42, borderRadius: 14, fontSize: 18, background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center" }}>{icon}</div>
      <div style={{ flex: 1 }}>
        <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{label}</p>
        {sub && <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{sub}</p>}
      </div>
      <div onClick={disabled ? undefined : onToggle} style={{
        width: 48, height: 28, borderRadius: 14, cursor: disabled ? "default" : "pointer", background: on ? COLORS.sage : COLORS.beige,
        transition: "background 0.25s ease", position: "relative", flexShrink: 0,
      }}>
        <div style={{ width: 22, height: 22, borderRadius: 11, background: COLORS.white, position: "absolute", top: 3, left: on ? 23 : 3, transition: "left 0.25s ease", boxShadow: "0 1px 4px rgba(0,0,0,0.15)" }} />
      </div>
    </div>
  );

  const LinkRow = ({ icon, label, sub, onClick, trailing }) => (
    <div onClick={onClick} style={{
      display: "flex", alignItems: "center", gap: 14, padding: "16px 4px",
      borderBottom: `1px solid ${COLORS.beige}`, cursor: onClick ? "pointer" : "default",
    }}>
      <div style={{ width: 42, height: 42, borderRadius: 14, fontSize: 18, background: COLORS.beige, display: "flex", alignItems: "center", justifyContent: "center" }}>{icon}</div>
      <div style={{ flex: 1 }}>
        <p style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>{label}</p>
        {sub && <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{sub}</p>}
      </div>
      {trailing || (
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={COLORS.textLight} strokeWidth="2" strokeLinecap="round"><polyline points="9 18 15 12 9 6"/></svg>
      )}
    </div>
  );

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      <ProfileSubHeader title="Settings" onBack={onBack} />
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 40px", opacity: loaded ? 1 : 0, transition: "opacity 0.4s ease" }}>

        {/* Appearance */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 4px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Appearance</p>
        <ToggleRow icon="🌙" label="Dark Mode" sub="Coming soon" on={darkMode} onToggle={() => setDarkMode(!darkMode)} disabled />

        {/* Language dropdown */}
        <div style={{ position: "relative" }}>
          <LinkRow
            icon="🌐" label="Language"
            onClick={() => setLangOpen(!langOpen)}
            trailing={
              <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
                <span style={{ fontSize: 13, color: COLORS.softBrown, fontFamily: "'DM Sans', sans-serif" }}>{lang}</span>
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={COLORS.textLight} strokeWidth="2.5" strokeLinecap="round"
                  style={{ transform: langOpen ? "rotate(180deg)" : "rotate(0deg)", transition: "transform 0.25s ease" }}>
                  <polyline points="6 9 12 15 18 9"/>
                </svg>
              </div>
            }
          />
          {langOpen && (
            <>
              <div onClick={() => setLangOpen(false)} style={{ position: "fixed", inset: 0, zIndex: 29 }} />
              <div style={{
                position: "absolute", top: "100%", right: 0, left: 0, zIndex: 30, marginTop: -4,
                background: COLORS.white, borderRadius: 16, padding: 6,
                boxShadow: "0 8px 30px rgba(74,55,40,0.15), 0 2px 8px rgba(74,55,40,0.08)",
                border: `1px solid ${COLORS.beige}`, maxHeight: 240, overflowY: "auto",
              }}>
                {languages.map(l => (
                  <button key={l} onClick={() => { setLang(l); setLangOpen(false); }} style={{
                    display: "flex", alignItems: "center", justifyContent: "space-between", width: "100%", padding: "10px 14px",
                    borderRadius: 10, border: "none", cursor: "pointer",
                    background: lang === l ? COLORS.beige : "transparent",
                    color: lang === l ? COLORS.darkBrown : COLORS.softBrown,
                    fontSize: 13, fontFamily: "'DM Sans', sans-serif", fontWeight: lang === l ? 600 : 400,
                    transition: "background 0.2s ease", textAlign: "left",
                  }}>
                    {l}
                    {lang === l && (
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                    )}
                  </button>
                ))}
              </div>
            </>
          )}
        </div>

        {/* General */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "24px 0 4px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>General</p>
        <ToggleRow icon="📍" label="Location Access" sub="For nearby store suggestions" on={locationAccess} onToggle={() => setLocationAccess(!locationAccess)} />
        <ToggleRow icon="📳" label="Haptic Feedback" sub="Vibrations on interactions" on={haptics} onToggle={() => setHaptics(!haptics)} />
        <ToggleRow icon="▶️" label="Auto-play Animations" sub="Card and transition effects" on={autoPlay} onToggle={() => setAutoPlay(!autoPlay)} />
        <ToggleRow icon="📶" label="Data Saver" sub="Reduce image quality on mobile data" on={saveData} onToggle={() => setSaveData(!saveData)} />

        {/* Storage */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "24px 0 4px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>Storage</p>
        <LinkRow icon="🗑️" label="Clear Cache" sub={cacheCleared ? "Cache cleared ✓" : "Free up storage space"} onClick={() => setCacheCleared(true)}
          trailing={cacheCleared
            ? <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={COLORS.sage} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
            : <span style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>12.4 MB</span>
          }
        />

        {/* About */}
        <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "24px 0 4px", letterSpacing: 0.5, textTransform: "uppercase", fontWeight: 500 }}>About</p>
        {[
          { label: "Terms of Service", icon: "📄" },
          { label: "Privacy Policy", icon: "🔒" },
          { label: "Help & Support", icon: "💬" },
          { label: "Rate the App", icon: "⭐" },
          { label: "Share with Friends", icon: "🔗" },
        ].map((item, i) => (
          <LinkRow key={i} icon={item.icon} label={item.label} />
        ))}

        {/* Delete Account */}
        <div style={{
          display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
          padding: 16, marginTop: 24, borderRadius: 16, cursor: "pointer",
          border: `1.5px solid ${COLORS.terracotta}30`,
        }}>
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke={COLORS.terracotta} strokeWidth="2" strokeLinecap="round">
            <polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
          </svg>
          <span style={{ fontSize: 14, color: COLORS.terracotta, fontFamily: "'DM Sans', sans-serif", fontWeight: 500 }}>Delete Account</span>
        </div>

        <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", textAlign: "center", margin: "24px 0 0" }}>
          La Petite Boulangerie v2.1.0
        </p>
      </div>
    </div>
  );
}

function FavouritesScreen({ favourites, onToggleFavourite, onProductClick, onQuickAdd, onNavigate, cartCount, onBack }) {
  const [loaded, setLoaded] = useState(false);
  useEffect(() => { setTimeout(() => setLoaded(true), 50); }, []);

  const favProducts = products.filter(p => favourites.includes(p.id));

  return (
    <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "8px 24px 16px", flexShrink: 0 }}>
        <button onClick={onBack} style={{ width: 40, height: 40, borderRadius: 14, background: COLORS.beige, border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={COLORS.darkBrown} strokeWidth="2.5" strokeLinecap="round"><polyline points="15 18 9 12 15 6"/></svg>
        </button>
        <h1 style={{ fontSize: 22, color: COLORS.darkBrown, margin: 0, fontWeight: 400 }}>Favourites</h1>
        {favProducts.length > 0 && (
          <span style={{ marginLeft: "auto", fontSize: 13, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif" }}>
            {favProducts.length} item{favProducts.length !== 1 ? "s" : ""}
          </span>
        )}
      </div>

      {/* Content */}
      <div style={{ flex: 1, overflowY: "auto", padding: "0 24px 100px" }}>
        {favProducts.length === 0 ? (
          <div style={{
            textAlign: "center", padding: "60px 20px",
            opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease",
          }}>
            <div style={{ fontSize: 56, marginBottom: 16 }}>❤️</div>
            <h2 style={{ fontSize: 20, color: COLORS.darkBrown, margin: "0 0 8px", fontWeight: 400 }}>No favourites yet</h2>
            <p style={{ fontSize: 14, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 24px", lineHeight: 1.5 }}>
              Tap the heart icon on any item to save it here
            </p>
            <button onClick={() => onNavigate("home")} style={{
              padding: "14px 32px", borderRadius: 14, border: "none", cursor: "pointer",
              background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
              color: COLORS.cream, fontSize: 14, fontFamily: "'DM Serif Display', serif",
              letterSpacing: 0.5, boxShadow: "0 6px 20px rgba(74,55,40,0.2)",
            }}>Browse Menu</button>
          </div>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            {favProducts.map((product, i) => (
              <div key={product.id} style={{
                display: "flex", gap: 14, padding: 16,
                background: COLORS.white, borderRadius: 18, border: `1px solid ${COLORS.beige}`,
                opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(10px)",
                transition: `all 0.4s cubic-bezier(0.22,1,0.36,1) ${i * 0.08}s`,
                boxShadow: `0 2px 10px ${COLORS.shadow}`,
              }}>
                <div onClick={() => onProductClick(product)} style={{
                  width: 80, height: 80, borderRadius: 14, flexShrink: 0, cursor: "pointer",
                  background: `linear-gradient(145deg, ${COLORS.beige}, ${COLORS.lightGold})`,
                  display: "flex", alignItems: "center", justifyContent: "center", fontSize: 36,
                }}>{product.image}</div>
                <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "center", minWidth: 0 }}>
                  <div style={{ display: "flex", alignItems: "flex-start", justifyContent: "space-between" }}>
                    <div onClick={() => onProductClick(product)} style={{ cursor: "pointer", flex: 1 }}>
                      <h3 style={{ fontSize: 15, color: COLORS.darkBrown, margin: 0, fontWeight: 400, letterSpacing: -0.2 }}>{product.name}</h3>
                      <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "4px 0" }}>{product.time}</p>
                    </div>
                    <div onClick={() => onToggleFavourite(product.id)} style={{
                      cursor: "pointer", padding: 4, flexShrink: 0,
                      transition: "transform 0.2s ease",
                    }}>
                      <svg width="18" height="18" viewBox="0 0 24 24" fill={COLORS.terracotta} stroke={COLORS.terracotta} strokeWidth="2" strokeLinecap="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                      </svg>
                    </div>
                  </div>
                  <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 4 }}>
                    <span style={{ fontSize: 17, color: COLORS.darkBrown }}>${product.price.toFixed(2)}</span>
                    <button onClick={() => onQuickAdd(product)} style={{
                      padding: "7px 16px", borderRadius: 10, border: "none", cursor: "pointer",
                      background: COLORS.darkBrown, color: COLORS.cream,
                      fontSize: 12, fontFamily: "'DM Sans', sans-serif", fontWeight: 500,
                      boxShadow: "0 2px 8px rgba(74,55,40,0.2)",
                    }}>Add to Cart</button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Bottom Nav */}
      <BottomNav active="favourites" onNavigate={onNavigate} cartCount={cartCount} />
    </div>
  );
}

function OrderSuccessScreen({ orderId, total, selectedAddress, onGoHome, onTrackOrder }) {
  const [loaded, setLoaded] = useState(false);
  const [confetti, setConfetti] = useState(true);
  useEffect(() => { setTimeout(() => setLoaded(true), 100); setTimeout(() => setConfetti(false), 3000); }, []);

  const addr = savedAddresses.find(a => a.id === selectedAddress) || savedAddresses[0];

  return (
    <div style={{
      flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center",
      padding: "40px 24px", position: "relative", overflow: "hidden",
    }}>
      {/* Confetti particles */}
      {confetti && Array.from({ length: 12 }).map((_, i) => (
        <div key={i} style={{
          position: "absolute",
          top: `${10 + Math.random() * 30}%`,
          left: `${5 + Math.random() * 90}%`,
          width: i % 3 === 0 ? 8 : 6,
          height: i % 3 === 0 ? 8 : 6,
          borderRadius: i % 2 === 0 ? "50%" : 2,
          background: [COLORS.golden, COLORS.terracotta, COLORS.sage, COLORS.caramel, COLORS.roseDust][i % 5],
          opacity: loaded ? 0 : 0.8,
          transform: loaded ? `translateY(${100 + i * 20}px) rotate(${i * 45}deg)` : `translateY(0) rotate(0deg)`,
          transition: `all ${1.5 + Math.random()}s cubic-bezier(0.22,1,0.36,1) ${i * 0.08}s`,
        }} />
      ))}

      {/* Success icon */}
      <div style={{
        width: 100, height: 100, borderRadius: 50, marginBottom: 28,
        background: `linear-gradient(135deg, ${COLORS.sage}30, ${COLORS.sage}15)`,
        display: "flex", alignItems: "center", justifyContent: "center",
        opacity: loaded ? 1 : 0, transform: loaded ? "scale(1)" : "scale(0.5)",
        transition: "all 0.6s cubic-bezier(0.34,1.56,0.64,1) 0.2s",
      }}>
        <div style={{
          width: 64, height: 64, borderRadius: 32,
          background: COLORS.sage, display: "flex", alignItems: "center", justifyContent: "center",
          boxShadow: `0 8px 25px ${COLORS.sage}40`,
        }}>
          <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke={COLORS.white} strokeWidth="2.5" strokeLinecap="round"><polyline points="20 6 9 17 4 12"/></svg>
        </div>
      </div>

      {/* Text */}
      <div style={{
        textAlign: "center",
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(15px)",
        transition: "all 0.5s ease 0.4s",
      }}>
        <h1 style={{ fontSize: 28, color: COLORS.darkBrown, margin: "0 0 8px", fontWeight: 400 }}>Order Placed!</h1>
        <p style={{ fontSize: 15, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "0 0 6px", lineHeight: 1.5 }}>
          Your fresh baked goods are being prepared
        </p>
        <p style={{ fontSize: 13, color: COLORS.softBrown, fontFamily: "'DM Sans', sans-serif", margin: 0 }}>
          Order {orderId}
        </p>
      </div>

      {/* Order summary card */}
      <div style={{
        width: "100%", marginTop: 32, padding: 22, borderRadius: 20,
        background: COLORS.white, border: `1px solid ${COLORS.beige}`,
        opacity: loaded ? 1 : 0, transform: loaded ? "translateY(0)" : "translateY(15px)",
        transition: "all 0.5s ease 0.55s",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 16 }}>
          <div>
            <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: 0, textTransform: "uppercase", letterSpacing: 0.5 }}>Estimated {addr.type === "Pickup" ? "Pickup" : "Delivery"}</p>
            <p style={{ fontSize: 17, color: COLORS.darkBrown, margin: "4px 0 0" }}>11:00 – 11:30 AM</p>
          </div>
          <div style={{ textAlign: "right" }}>
            <p style={{ fontSize: 11, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: 0, textTransform: "uppercase", letterSpacing: 0.5 }}>Total</p>
            <p style={{ fontSize: 17, color: COLORS.darkBrown, margin: "4px 0 0" }}>${total.toFixed(2)}</p>
          </div>
        </div>
        <div style={{ height: 1, background: COLORS.beige, marginBottom: 16 }} />
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <span style={{ fontSize: 16 }}>{addr.icon}</span>
          <div>
            <p style={{ fontSize: 13, color: COLORS.darkBrown, fontFamily: "'DM Sans', sans-serif", fontWeight: 500, margin: 0 }}>{addr.label}</p>
            <p style={{ fontSize: 12, color: COLORS.textLight, fontFamily: "'DM Sans', sans-serif", margin: "2px 0 0" }}>{addr.address}</p>
          </div>
        </div>
      </div>

      {/* Progress tracker */}
      <div style={{
        width: "100%", marginTop: 20, display: "flex", alignItems: "center", gap: 0,
        opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease 0.65s",
      }}>
        {["Confirmed", "Preparing", "Ready"].map((step, i) => (
          <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center" }}>
            <div style={{ display: "flex", alignItems: "center", width: "100%" }}>
              {i > 0 && <div style={{ flex: 1, height: 2, background: i === 0 ? COLORS.sage : COLORS.beige }} />}
              <div style={{
                width: 24, height: 24, borderRadius: 12, flexShrink: 0,
                background: i === 0 ? COLORS.sage : COLORS.beige,
                display: "flex", alignItems: "center", justifyContent: "center",
              }}>
                {i === 0 && <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={COLORS.white} strokeWidth="3"><polyline points="20 6 9 17 4 12"/></svg>}
              </div>
              {i < 2 && <div style={{ flex: 1, height: 2, background: COLORS.beige }} />}
            </div>
            <span style={{ fontSize: 10, fontFamily: "'DM Sans', sans-serif", marginTop: 6, color: i === 0 ? COLORS.sage : COLORS.textLight, fontWeight: i === 0 ? 600 : 400 }}>{step}</span>
          </div>
        ))}
      </div>

      {/* Buttons */}
      <div style={{
        width: "100%", marginTop: 32, display: "flex", flexDirection: "column", gap: 10,
        opacity: loaded ? 1 : 0, transition: "opacity 0.5s ease 0.75s",
      }}>
        <button onClick={onGoHome} style={{
          width: "100%", padding: "16px 0", borderRadius: 16, border: "none", cursor: "pointer",
          background: `linear-gradient(135deg, ${COLORS.darkBrown}, ${COLORS.softBrown})`,
          color: COLORS.cream, fontSize: 15, fontFamily: "'DM Serif Display', serif",
          letterSpacing: 0.5, boxShadow: "0 6px 20px rgba(74,55,40,0.2)",
        }}>Continue Shopping</button>
        <button onClick={onTrackOrder} style={{
          width: "100%", padding: "14px 0", borderRadius: 16,
          border: `1.5px solid ${COLORS.darkBrown}`, background: "transparent",
          cursor: "pointer", fontSize: 14, fontFamily: "'DM Sans', sans-serif",
          fontWeight: 500, color: COLORS.darkBrown,
        }}>View Order Details</button>
      </div>
    </div>
  );
}

function BottomNav({ active, onNavigate, cartCount = 0 }) {
  const items = [
    { id: "home", icon: (c) => <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>, label: "Home" },
    { id: "favourites", icon: (c, fill) => <svg width="22" height="22" viewBox="0 0 24 24" fill={fill || "none"} stroke={c} strokeWidth="2" strokeLinecap="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>, label: "Favourites" },
    { id: "cart", icon: (c) => <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>, label: "Cart" },
    { id: "profile", icon: (c) => <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>, label: "Profile" },
  ];

  return (
    <div style={{
      position: "absolute", bottom: 0, left: 0, right: 0,
      display: "flex", justifyContent: "space-around", alignItems: "center",
      padding: "10px 16px 24px", background: COLORS.warmWhite,
      borderTop: `1px solid ${COLORS.beige}`, zIndex: 10,
    }}>
      {items.map(item => (
        <div key={item.id} onClick={() => onNavigate && onNavigate(item.id)} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 3, cursor: "pointer", position: "relative" }}>
          {item.id === "favourites"
            ? item.icon(active === item.id ? COLORS.terracotta : COLORS.textLight, active === item.id ? COLORS.terracotta : "none")
            : item.icon(active === item.id ? COLORS.darkBrown : COLORS.textLight)
          }
          {item.id === "cart" && cartCount > 0 && (
            <div style={{ position: "absolute", top: -4, right: -6, width: 18, height: 18, borderRadius: 9, background: COLORS.terracotta, color: "#fff", fontSize: 10, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: "'DM Sans', sans-serif", fontWeight: 600 }}>{cartCount}</div>
          )}
          <span style={{
            fontSize: 10, fontFamily: "'DM Sans', sans-serif", fontWeight: active === item.id ? 600 : 400,
            color: active === item.id ? (item.id === "favourites" ? COLORS.terracotta : COLORS.darkBrown) : COLORS.textLight,
          }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
}

// --- MAIN APP ---
export default function BakeryApp() {
  const [screen, setScreen] = useState("home");
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [cart, setCart] = useState([
    { product: products[0], quantity: 1 },
  ]);
  const [selectedAddress, setSelectedAddress] = useState(1);
  const [lastOrderTotal, setLastOrderTotal] = useState(0);
  const [lastOrderId, setLastOrderId] = useState("");
  const [favourites, setFavourites] = useState([]);
  const [addressReturnScreen, setAddressReturnScreen] = useState("home");
  const [showAddressSheet, setShowAddressSheet] = useState(false);
  const [previousScreen, setPreviousScreen] = useState("home");

  const toggleFavourite = (productId) => {
    setFavourites(prev => prev.includes(productId) ? prev.filter(id => id !== productId) : [...prev, productId]);
  };

  const addToCart = (product, quantity) => {
    setCart(prev => {
      const existing = prev.findIndex(item => item.product.id === product.id);
      if (existing >= 0) {
        const updated = [...prev];
        updated[existing] = { ...updated[existing], quantity: updated[existing].quantity + quantity };
        return updated;
      }
      return [...prev, { product, quantity }];
    });
  };

  const handleAddToCart = (product, quantity) => {
    addToCart(product, quantity);
    setScreen("cart");
  };

  const handleQuickAdd = (product) => {
    addToCart(product, 1);
  };

  const handleUpdateQuantity = (index, qty) => {
    if (qty <= 0) {
      setCart(prev => prev.filter((_, i) => i !== index));
    } else {
      setCart(prev => prev.map((item, i) => i === index ? { ...item, quantity: qty } : item));
    }
  };

  const handleReorder = (order) => {
    order.items.forEach(item => {
      const matchedProduct = products.find(p => p.name === item.name);
      if (matchedProduct) addToCart(matchedProduct, 1);
    });
    setScreen("cart");
  };

  const handleNavigation = (tab) => {
    setPreviousScreen(screen);
    if (tab === "home") setScreen("home");
    else if (tab === "favourites") setScreen("favourites");
    else if (tab === "cart") setScreen("cart");
    else if (tab === "profile") setScreen("profile");
  };

  const cartCount = cart.reduce((s, i) => s + i.quantity, 0);

  return (
    <PhoneFrame>
      {screen === "home" && (
        <HomeScreen
          onProductClick={(p) => { setSelectedProduct(p); setPreviousScreen("home"); setScreen("product"); }}
          onCartClick={() => setScreen("cart")}
          onOrdersClick={() => { setPreviousScreen("home"); setScreen("orders"); }}
          onQuickAdd={handleQuickAdd}
          onNavigate={handleNavigation}
          cartCount={cartCount}
          selectedAddress={selectedAddress}
          onAddressOpen={() => setShowAddressSheet(true)}
          favourites={favourites}
          onToggleFavourite={toggleFavourite}
        />
      )}
      {screen === "product" && selectedProduct && (
        <ProductDetailScreen
          product={selectedProduct}
          onBack={() => setScreen(previousScreen)}
          onAddToCart={handleAddToCart}
          onProductClick={(p) => { setSelectedProduct(p); }}
          isFav={favourites.includes(selectedProduct.id)}
          onToggleFav={() => toggleFavourite(selectedProduct.id)}
        />
      )}
      {screen === "cart" && (
        <CartScreen
          cart={cart}
          onBack={() => setScreen("home")}
          onCheckout={() => setScreen("checkout")}
          onUpdateQuantity={handleUpdateQuantity}
          onQuickAdd={handleQuickAdd}
          selectedAddress={selectedAddress}
          onAddressOpen={() => setShowAddressSheet(true)}
        />
      )}
      {screen === "checkout" && (
        <CheckoutScreen
          cart={cart}
          onBack={() => setScreen("cart")}
          selectedAddress={selectedAddress}
          onPlaceOrder={() => {
            const t = cart.reduce((s, i) => s + i.product.price * i.quantity, 0) + 2.50;
            setLastOrderTotal(t);
            setLastOrderId("#" + (2848 + Math.floor(Math.random() * 100)));
            setCart([]);
            setScreen("order-success");
          }}
        />
      )}
      {screen === "orders" && (
        <RecentOrdersScreen onBack={() => setScreen(previousScreen)} onReorder={handleReorder} />
      )}
      {screen === "order-success" && (
        <OrderSuccessScreen
          orderId={lastOrderId}
          total={lastOrderTotal}
          selectedAddress={selectedAddress}
          onGoHome={() => setScreen("home")}
          onTrackOrder={() => { setPreviousScreen("home"); setScreen("orders"); }}
        />
      )}
      {screen === "favourites" && (
        <FavouritesScreen
          favourites={favourites}
          onToggleFavourite={toggleFavourite}
          onProductClick={(p) => { setSelectedProduct(p); setPreviousScreen("favourites"); setScreen("product"); }}
          onQuickAdd={handleQuickAdd}
          onNavigate={handleNavigation}
          cartCount={cartCount}
          onBack={() => setScreen(previousScreen)}
        />
      )}
      {screen === "profile" && (
        <ProfileScreen
          onNavigate={handleNavigation}
          cartCount={cartCount}
          onOrdersClick={() => { setPreviousScreen("profile"); setScreen("orders"); }}
          onFavouritesClick={() => { setPreviousScreen("profile"); setScreen("favourites"); }}
          onSubScreen={(s) => setScreen("profile-" + s)}
        />
      )}
      {screen === "profile-edit-profile" && (
        <EditProfileScreen onBack={() => setScreen("profile")} />
      )}
      {screen === "profile-addresses" && (
        <SavedAddressesScreen onBack={() => setScreen("profile")} selectedAddress={selectedAddress} onAddressSelect={setSelectedAddress} onAddNew={() => { setAddressReturnScreen("profile-addresses"); setScreen("add-address"); }} />
      )}
      {screen === "add-address" && (
        <AddNewAddressScreen onBack={() => setScreen(addressReturnScreen)} onSave={() => setScreen(addressReturnScreen)} />
      )}
      {screen === "profile-payments" && (
        <PaymentMethodsScreen onBack={() => setScreen("profile")} />
      )}
      {screen === "profile-notifications" && (
        <NotificationsScreen onBack={() => setScreen("profile")} />
      )}
      {screen === "profile-settings" && (
        <SettingsScreen onBack={() => setScreen("profile")} />
      )}

      {/* Address picker bottom sheet — rendered at app level to avoid overflow clipping */}
      <AddressBottomSheet
        open={showAddressSheet}
        selectedAddress={selectedAddress}
        onSelect={setSelectedAddress}
        onAddNew={() => { setAddressReturnScreen(screen); setScreen("add-address"); }}
        onClose={() => setShowAddressSheet(false)}
      />
    </PhoneFrame>
  );
}
